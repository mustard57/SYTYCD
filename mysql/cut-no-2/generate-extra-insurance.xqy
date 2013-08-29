import module namespace generate-lib = "http://marklogic.com/SYTYCD/generate-lib" at "/generate-lib.xqy";

declare variable $schema-file := "c:\Users\ktune\SYTYCD-Dummy-Data\mysql\cut-no-1\sytycd.insurance.extra.schema.sql";

declare variable $table-config := 
<root>
    <schema-name>NewInsuranceCo</schema-name>
    <!-- Idea here is to create 1000 customers -->
    <!-- and policies for each -->
    <!-- we then move these policies into the '2000' range -->
    <table rows="1000">
        <table-name>CLIENT</table-name>
        <pkey content="counter:3000">auto</pkey>
        <fields>
            <field content="/first-name.csv[2]">TITLE</field>
            <field content="/first-name.csv[3]">FIRST_NAME</field>
            <field content="/surname.csv[1]">FAMILY_NAME</field>
            <field content="range:1943,1991|-|range:1,12|-|range:1,28">DOB</field>            
            <field content="/postcodes.csv[10]|random: dddddd">PHONE_1</field>
            <field content="random:07ddd dddddd">PHONE_2</field>
            <field content="/first-name.csv[3]|.|/surname.csv[1]|@|/domain.csv[1]">EMAIL</field>
            <field content="/first-name.csv[1]">M_OR_F</field>       
            <field content="/occupation.csv[1]">PROFESSION</field>                 
            <fkey content="counter:3000">ADDRESS</fkey>            
        </fields>
    </table>
    <!-- 12 branches 112 = 100 + 12 -->
    <table rows="1000">
        <table-name >ADDRESS</table-name>
        <pkey content="counter:3000">auto</pkey>
        <fields>
            <field content="range:1,80| |/roads.csv[1]">ADDRESS_1</field>
            <field content="/postcodes.csv[6]">ADDRESS_2</field>
            <field content="/postcodes.csv[7]">ADDRESS_3</field>            
            <field content="/postcodes.csv[1]| |random:dWW">POSTCODE</field>
        </fields>
    </table>
    
    <table>
        <table-name>INSURANCE-TYPE</table-name>
        <pkey>auto</pkey>
        <enum>
            <val>Home</val>
            <val>Life</val>
            <val>Car</val>            
        </enum>
    </table>    
    <table>
        <table-name>CONTRACT</table-name>
        <pkey>auto</pkey>
        <fields>
            <fkey>INSURANCE-TYPE</fkey>
            <field>POLICY-NO</field>
            <fkey>CLIENT</fkey>            
            <field content="function:dateLastYear,DUMMY">START-DATE</field>
            <field content="function:add-one-year,START-DATE">END-DATE</field>
            <field content="range:1,500|.|random:dd">PREMIUM</field>
        </fields>
    </table>  
    <table>
        <table-name>CAR_POLICY</table-name>
        <pkey>auto</pkey>
        <fields>
            <fkey>CONTRACT</fkey>
            <field>MANUFACTURER</field>
            <field>MODEL</field>
            <field>REGISTRATION</field>            
        </fields>
    </table>     
    
    <!-- Let's say 60 people with car insurance --> 
    <data rows="1000">
        <table-name>CONTRACT</table-name>
        <pkey content="counter:3000">POLICY-ID</pkey>
        <fields>
            <fkey content="3">INSURANCE-TYPE</fkey>
            <field content="random:WW/dddd/dd W">POLICY-NO</field>            
            <fkey content="unique-id-from-map:">CLIENT</fkey>
            <field content="function:dateLastYear,DUMMY">START-DATE</field>
            <field content="function:add-one-year,START-DATE">END-DATE</field>
            <field content="range:1,500|.|random:dd">PREMIUM</field>
        </fields>
    </data>   
    <data rows="1000">
        <table-name>CAR_POLICY</table-name>
        <pkey content="counter:3000">auto</pkey>
        <fields>
            <fkey content="counter:3000">CONTRACT</fkey>            
            <field content="/car-make-model.csv[1]">MANUFACTURER</field>
            <field content="/car-make-model.csv[2]">MODEL</field>
            <field content="random:WW0d WWW">REGISTRATION</field>            
        </fields>
    </data>         
    <!-- Policy type 2 - home insurance -->
    <!-- 30 people -->
    <data rows="1000">
        <table-name>CONTRACT</table-name>
        <pkey content="counter:4000">POLICY-ID</pkey>
        <fields>
            <fkey content="1">INSURANCE-TYPE</fkey>
            <field content="random:WW/dddd/dd W">POLICY-NO</field>            
            <fkey content="unique-id-from-map:">CLIENT</fkey>            
            <field content="function:dateLastYear,DUMMY">START-DATE</field>
            <field content="function:add-one-year,START-DATE">END-DATE</field>
            <field content="range:1,500|.|random:dd">PREMIUM</field>
        </fields>
    </data>   
    <!-- 20 with life insurance -->
    <data rows="1000">
        <table-name>CONTRACT</table-name>
        <pkey content="counter:5000">POLICY-ID</pkey>
        <fields>
            <fkey content="2">INSURANCE-TYPE</fkey>
            <field content="random:random:WW/dddd/dd W">POLICY-NO</field>            
            <fkey content="unique-id-from-map:">CLIENT</fkey>            
            <field content="function:dateLastYear,DUMMY">START-DATE</field>
            <field content="function:add-one-year,START-DATE">END-DATE</field>
            <field content="range:1,500|.|random:dd">PREMIUM</field>
        </fields>
    </data>       
</root>;

generate-lib:generate-schema($table-config,$schema-file)