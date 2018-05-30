package org.sonar.pligins.xquery.testRunner;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.concurrent.LinkedBlockingQueue;

/**
 * Author: Alexander Jones <alexander.jones@flatironssolutions.com></br>
 * Date: 2016-02-23</br>
 *
 * ...
 */
public class ReflectionCommon {

	public static Object getValueIgnoreVisibility(Object obj, String cast, String path) {
		try {

			/*
			 * cast intput object to desired type
			 */
			obj = Class.forName(cast).cast(obj);

			/*
			 * return the result of evaluating path
			 */
			return getValueIgnoreVisibility(obj, path);

		} catch (ClassNotFoundException e) {

			e.printStackTrace();
			System.exit(-1);

		} catch (IllegalArgumentException e) {

			e.printStackTrace();
			System.exit(-1);

		} catch (NoSuchFieldException e) {

			e.printStackTrace();
			System.exit(-1);
		}
		return obj;
	}

	public static Object getValueIgnoreVisibility(Object obj, String path) throws NoSuchFieldException {
		try {

			@SuppressWarnings("rawtypes")
			Class clazz = obj.getClass();

			/*
			 * For each part of the path find a field that matches
			 * in the current class and use the value as the next
			 * object and class to check
			 */
			for (String part : path.split("\\.")) {

				Field field = null;

				/*
				 * Iterate over this class and all superclasses until we find the right field
				 */
				Class thisClass = clazz;

				outer:
				while (thisClass != null) {

					for (Field declaredField : thisClass.getDeclaredFields()) {
						if (declaredField.getName().equals(part)) {

							field = declaredField;
							break outer;
						}
					}

					for (Field field1 : thisClass.getFields()) {
						if (field1.getName().equals(part)) {

							field = field1;
							break outer;
						}
					}

					thisClass = thisClass.getSuperclass();
				}

				/*
				 * Did we find the field?
				 */
				if (field != null) {

					boolean isAccessible = field.isAccessible();
					field.setAccessible(true);
					Object value = field.get(obj);
					obj = value;

					if (obj == null) {
						return null;
					}

					clazz = obj.getClass();
					field.setAccessible(isAccessible);

				} else {

					/*
					 * The field did not exits
					 */
					String msg = String.format("The field %s in %s was not found", part, path);
					throw new NoSuchFieldException(msg);
				}
			}
		} catch (IllegalArgumentException e) {

			e.printStackTrace();
			System.exit(-1);

		} catch (IllegalAccessException e) {

			/*
			 * This error will only be thrown if we are running
			 * under a security manager that doesn't allow changing
			 * the visibility of a field
			 */
			e.printStackTrace();
			System.exit(-1);
		}

		return obj;
	}

	/*
	 * FOR DEBUGGING PURPOSES ONLY
	 *
	 * Function for locating fields of interest in an object or it's fields.
	 *
	 * Writes output to classTracer.log
	 */
	public static void printNonNullSubFields(Object objIn) {

		HashSet<Integer> added = new HashSet<Integer>();
		LinkedBlockingQueue<Object> objsToExpand = new LinkedBlockingQueue<Object>();
		objsToExpand.offer(objIn);
		LinkedBlockingQueue<String> path = new LinkedBlockingQueue<String>();
		path.add(objIn.getClass().getCanonicalName());

		@SuppressWarnings({ "unchecked", "rawtypes" })
		ArrayList<Class> printableClasses = new ArrayList<Class>(Arrays.asList(
				Byte.class, Character.class, Double.class, Float.class, Integer.class, Long.class, Short.class, Boolean.class, String.class));

		ArrayList<String[]> out = new ArrayList<String[]>();

		while (!objsToExpand.isEmpty()) {

			Object obj = objsToExpand.poll();
			String thisPath = path.poll();

			@SuppressWarnings("rawtypes")
			Class clazz = obj.getClass();

			ArrayList<Field> fields = new ArrayList<Field>();
			@SuppressWarnings("rawtypes")
			Class thisClass = clazz;

			while (thisClass != null) {

				fields.addAll(Arrays.asList(thisClass.getDeclaredFields()));
				thisClass = thisClass.getSuperclass();
			}

			for (Field field : fields) {
				try {

					boolean isAccessible = field.isAccessible();
					field.setAccessible(true);
					Object value = field.get(obj);

					if (value != null) {

						@SuppressWarnings("rawtypes")
						Class clazz2 = value.getClass();

						String fieldPath = String.format("%s.%s", thisPath, field.getName());

						if (printableClasses.contains(clazz2)) {
							out.add(new String[] {

								field.getGenericType().toString(),
								value.toString(),
								clazz.getCanonicalName(),
								field.getName(),
								thisPath
							});
						} else {

							Integer hash = new Integer(value.hashCode());

							if(!added.contains(hash)) {

								objsToExpand.add(value);
								path.add(fieldPath);
								added.add(hash);
							}
						}
					}

					field.setAccessible(isAccessible);

				} catch (IllegalArgumentException e) {

					e.printStackTrace();
					System.exit(-1);

				} catch (IllegalAccessException e) {

					e.printStackTrace();
					System.exit(-1);
				}
			}
		}

		if (!out.isEmpty()) {

			int[] colWidths = new int[out.get(0).length];

			for (int i = 0 ; i < colWidths.length ; i ++) {
				colWidths[i] = 0;
			}

			out.add(0, new String[] {"type", "value", "package", "class", "path"});

			for (String[] row : out) {
				for (int i = 0 ; i < row.length ; i ++) {

					int width = row[i].length();

					if ((width > colWidths[i]) && (row[i].indexOf('\n') < 0)) {

						colWidths[i] = width;
						System.out.println(row[i] + " is " + width + " characters long");
					}
				}
			}

			File outFile = new File("classTracer_" + objIn.getClass().getSimpleName() + "_instance_.log");
			PrintWriter printWriter = null;

			try {
				printWriter = new PrintWriter(outFile);

				for (String[] row : out) {

					printWriter.format(
							"(%" + colWidths[0] + "s) %-" + colWidths[1] + "s = %" + colWidths[2] + "s.%" + colWidths[3] + "s from %" + colWidths[4] + "s\n",
							row);
				}
			} catch (FileNotFoundException e) {

				e.printStackTrace();
				System.exit(-1);

			} finally {
				printWriter.close();
			}
		}
	}
}
