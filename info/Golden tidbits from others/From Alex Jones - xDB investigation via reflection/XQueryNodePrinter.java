package org.sonar.pligins.xquery.testRunner;

import com.xhive.xquery.XQueryExpr;

/**
 * Author: Alexander Jones <alexander.jones@flatironssolutions.com></br>
 * Date: 2016-02-23</br>
 *
 * ...
 */
public class XQueryNodePrinter {

	public static String xqueryTreeToXML(Object obj, int indent) {

		StringBuilder sb = new StringBuilder();
		try {
			if (obj instanceof com.xhive.xquery.bk) {
				com.xhive.xquery.bk val = (com.xhive.xquery.bk) obj;
				try {
					sb.append(String.format("%" + (indent * 2) + "s", ""));
					sb.append("<query>\n");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVT");
					sb.append(xqueryTreeToXML(result, indent + 1));
					sb.append(String.format("%" + (indent * 2) + "s", ""));
					sb.append("</query>\n");
				} catch (IllegalArgumentException e) {
					e.printStackTrace(); System.exit(-1);
				} catch (SecurityException e) {
					e.printStackTrace(); System.exit(-1);
				}
			} else if (obj instanceof com.xhive.xDB_10_5_11.ia) {
				com.xhive.xDB_10_5_11.ia val = (com.xhive.xDB_10_5_11.ia) obj;
				try {
					sb.append(String.format("%" + (indent * 2) + "s", ""));
					sb.append("<get-variable");
					{
						sb.append(" variable=\"");
						Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVU");
						sb.append(result.toString());
						sb.append("\"");
					}
					{
						sb.append(" line=\"");
						Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aZt");
						sb.append(result.toString());
						sb.append("\"");
					}
					sb.append(">\n");
					{
						Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVP");
						sb.append(xqueryTreeToXML(result, indent + 1));
					}
					{
						Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVQ");
						sb.append(xqueryTreeToXML(result, indent + 1));
					}
					sb.append(String.format("%" + (indent * 2) + "s", ""));
					sb.append("</get-variable>\n");
				} catch (IllegalArgumentException e) {
					e.printStackTrace(); System.exit(-1);
				} catch (SecurityException e) {
					e.printStackTrace(); System.exit(-1);
				}
			} else if (obj instanceof com.xhive.xDB_10_5_11.hx) {
				com.xhive.xDB_10_5_11.hx val = (com.xhive.xDB_10_5_11.hx) obj;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("<for");
				{
					sb.append(" variable=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVU");
					sb.append(result);
					sb.append("\"");
				}
				{
					sb.append(" line=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aZt");
					sb.append(result.toString());
					sb.append("\"");
				}
				sb.append(">\n");
				{
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVP");
					sb.append(xqueryTreeToXML(result, indent + 1));
				}
				{
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVQ");
					sb.append(xqueryTreeToXML(result, indent + 1));
				}
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("</for>\n");
				System.out.println();
			} else if (obj instanceof com.xhive.xquery.ay) {
				com.xhive.xquery.ay val = (com.xhive.xquery.ay) obj;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("<expand-list");
				{
					sb.append(" line=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aZt");
					sb.append(result.toString());
					sb.append("\"");
				}
				sb.append(">\n");
				indent ++;
				{
					sb.append(String.format("%" + ((indent) * 2) + "s", ""));
					sb.append("<start>\n");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVP");
					sb.append(xqueryTreeToXML(result, indent + 1));
					sb.append(String.format("%" + (indent * 2) + "s", ""));
					sb.append("</start>\n");
				}
				{
					sb.append(String.format("%" + (indent * 2) + "s", ""));
					sb.append("<end>\n");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVQ");
					sb.append(xqueryTreeToXML(result, indent + 1));
					sb.append(String.format("%" + (indent * 2) + "s", ""));
					sb.append("</end>\n");
				}
				indent --;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("</expand-list>\n");
			} else if (obj instanceof com.xhive.xquery.context.k) {
				com.xhive.xquery.context.k val = (com.xhive.xquery.context.k) obj;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("<variable");
				{
					sb.append(" name=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVU");
					sb.append(result.toString());
					sb.append("\"");
				}
				{
					sb.append(" line=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aZt");
					sb.append(result.toString());
					sb.append("\"");
				}
				sb.append("/>\n");
			} else if (obj instanceof com.xhive.xDB_10_5_11.hb) {
				com.xhive.xDB_10_5_11.hb val = (com.xhive.xDB_10_5_11.hb) obj;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("<set-variable");
				{
					sb.append(" line=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aZt");
					sb.append(result.toString());
					sb.append("\"");
				}
				sb.append(">\n");
				{
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVQ");
					sb.append(xqueryTreeToXML(result, indent + 1));
				}
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("</set-variable>\n");
			} else if (obj instanceof com.xhive.xquery.functions.i) {
				com.xhive.xquery.functions.i val = (com.xhive.xquery.functions.i) obj;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("<call-func-with-args");
				{
					sb.append(" qname=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "qname");
					sb.append(result.toString());
					sb.append("\"");
				}
				{
					sb.append(" line=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aZt");
					sb.append(result.toString());
					sb.append("\"");
				}
				sb.append(">\n");
				{
					XQueryExpr[] result = (XQueryExpr[]) ReflectionCommon.getValueIgnoreVisibility(val, "blf");
					for (XQueryExpr expr : result) {
						sb.append(xqueryTreeToXML(expr, indent + 1));
					}
				}
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("</call-func-with-args>\n");
			} else if (obj instanceof com.xhive.xquery.au) {
				com.xhive.xquery.au val = (com.xhive.xquery.au) obj;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("<string");
				{
					sb.append(" line=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aZt");
					sb.append(result.toString());
					sb.append("\"");
				}
				sb.append(">\n");
				{
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aYt");
					sb.append(result.toString());
				}
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("</string>\n");
			} else if (obj instanceof com.xhive.xquery.ab) {
				com.xhive.xquery.ab val = (com.xhive.xquery.ab) obj;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("<int");
				{
					sb.append(" line=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aZt");
					sb.append(result.toString());
					sb.append("\"");
				}
				sb.append(">\n");
				{
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aWN");
					sb.append(String.format("%" + ((indent + 1) * 2) + "s", ""));
					sb.append(result.toString());
					sb.append("\n");
				}
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("</int>\n");
			} else if (obj instanceof com.xhive.xquery.y) {
				com.xhive.xquery.y val = (com.xhive.xquery.y) obj;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("<if");
				{
					sb.append(" line=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aZt");
					sb.append(result.toString());
					sb.append("\"");
				}
				sb.append(">\n");
				indent ++;
				{
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aWD");
					sb.append(xqueryTreeToXML(result, indent + 1));
				}
				{
					sb.append(String.format("%" + ((indent) * 2) + "s", ""));
					sb.append("<then>\n");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aWE");
					sb.append(xqueryTreeToXML(result, indent + 1));
					sb.append(String.format("%" + (indent * 2) + "s", ""));
					sb.append("</then>\n");
				}
				{
					sb.append(String.format("%" + ((indent) * 2) + "s", ""));
					sb.append("<else>\n");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aWF");
					sb.append(xqueryTreeToXML(result, indent + 1));
					sb.append(String.format("%" + (indent * 2) + "s", ""));
					sb.append("</else>\n");
				}
				indent --;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("</if>\n");
			} else if (obj instanceof com.xhive.xDB_10_5_11.gn) {
				com.xhive.xDB_10_5_11.gn val = (com.xhive.xDB_10_5_11.gn) obj;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("<case");
				{
					sb.append(" line=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aZt");
					sb.append(result.toString());
					sb.append("\"");
				}
				{
					sb.append(" operator=\"");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "bau");
					sb.append(result.toString());
					sb.append("\"");
				}
				sb.append(">\n");
				indent ++;
				{
					sb.append(String.format("%" + ((indent) * 2) + "s", ""));
					sb.append("<left>\n");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVP");
					sb.append(xqueryTreeToXML(result, indent + 1));
					sb.append(String.format("%" + (indent * 2) + "s", ""));
					sb.append("</then>\n");
				}
				{
					sb.append(String.format("%" + ((indent) * 2) + "s", ""));
					sb.append("<right>\n");
					Object result = ReflectionCommon.getValueIgnoreVisibility(val, "aVQ");
					sb.append(xqueryTreeToXML(result, indent + 1));
					sb.append(String.format("%" + (indent * 2) + "s", ""));
					sb.append("</right>\n");
				}
				indent --;
				sb.append(String.format("%" + (indent * 2) + "s", ""));
				sb.append("</case>\n");
			} else {
				System.out.println();
			}
		} catch (NoSuchFieldException e) {

			e.printStackTrace();
			System.exit(-1);
		}
		return sb.toString();
	}

}
