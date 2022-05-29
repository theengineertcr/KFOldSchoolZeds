class Utility extends object
    abstract;

// colors and tags, maybe later I will convert this to a config array
struct ColorRecord
{
    var string ColorName;            // color name, for comfort
    var string ColorTag;             // color tag
    var Color Color;                 // RGBA values
};
var array<ColorRecord> ColorList;   // color list


// parse tags -> create colors
final static function string ParseTagsStatic(string input)
{
    local int i;

    for (i = 0; i < default.ColorList.Length; i++)
    {
        ReplaceText(input, default.ColorList[i].ColorTag, class'GameInfo'.static.MakeColorCode(default.ColorList[i].Color));
    }
    return input;
}

// remove tags, aka ^r^
final static function string StriptTagsStatic(string input)
{
    local int i;

    for (i = 0; i < default.ColorList.Length; i++)
    {
        ReplaceText(input, default.ColorList[i].ColorTag, "");
    }
    return input;
}

// remove colors, aka chr(27)
final static function string StripColorStatic(string s)
{
    local int p;

    p = InStr(s, chr(27));

    while (p >= 0)
    {
        s = left(s, p) $ mid(S, p + 4);
        p = InStr(s, Chr(27));
    }
    return s;
}

defaultproperties
{
    ColorList(00)=(ColorName="Blue",ColorTag="^b^",Color=(B=200,G=100,R=50,A=0))
    ColorList(01)=(ColorName="Green",ColorTag="^g^",Color=(B=0,G=200,R=0,A=0))
    ColorList(02)=(ColorName="Light Orange",ColorTag="^lo^",Color=(B=177,G=216,R=254,A=0))
    ColorList(03)=(ColorName="Light Purple",ColorTag="^lp^",Color=(B=91,G=54,R=77,A=0))
    ColorList(04)=(ColorName="Orange",ColorTag="^o^",Color=(B=0,G=127,R=255,A=0))
    ColorList(05)=(ColorName="Pink",ColorTag="^pi^",Color=(B=196,G=72,R=251,A=0))
    ColorList(06)=(ColorName="Purple",ColorTag="^p^",Color=(B=173,G=52,R=112,A=0))
    ColorList(07)=(ColorName="Red",ColorTag="^r^",Color=(B=50,G=50,R=200,A=0))
    ColorList(08)=(ColorName="Violet",ColorTag="^v^",Color=(B=139,G=0,R=255,A=0))
    ColorList(09)=(ColorName="White",ColorTag="^w^",Color=(B=255,G=255,R=255,A=0))
    ColorList(10)=(ColorName="Yellow",ColorTag="^y^",Color=(B=0,G=255,R=255,A=0))
}