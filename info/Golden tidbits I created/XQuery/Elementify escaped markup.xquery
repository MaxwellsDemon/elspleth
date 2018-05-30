(: 
    Takes a sequence of elements with arbitarily deep children and interprets every text node as embedded markup 
    Thus, [text node] -> [A sequence of text nodes and/or elements]
:)
declare function local:elementify($elements as element()*) as element()*
{
    for $element in $elements
    let $newChildren :=
        for $childNode in ($element/attribute::*, $element/child::node())
        return
            if ($childNode instance of text()) then
                local:expandText($childNode)
            else if ($childNode instance of element()) then
                local:elementify($childNode)
            else
                $childNode
    return
        element {$element/local-name()} {$newChildren}
};

declare function local:expandText($text as text()) as node()*
{
    (: Add a temporary wrapper element to the text so the resulting string is valid XML and thus valid XQuery :)
    let $text := concat("<root>", string($text),"</root>")
    let $root := xhive:evaluate($text)
    return $root/node()
};

let $rec := 
    <rec id="123">
        <title id="777">MyTitle</title>
        <name id="42">my awesome text with &lt;sup id="666">TM&lt;/sup> superscripted things</name>
    </rec>

return local:elementify($rec)
