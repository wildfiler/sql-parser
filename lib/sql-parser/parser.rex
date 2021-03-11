class SQLParser::Parser

option
  ignorecase

macro
  DIGIT   [0-9]
  UINT    {DIGIT}+\.?
  UFLOAT   [0-9]*\.[0-9]+

  BLANK   \s+

  YEARS   {UINT}
  MONTHS  {UINT}
  DAYS    {UINT}

  # Ugly workaround
  # Rexical matches by position not by the longest match.
  # This makes that any identifier that starts with a reserved word
  # (for instance: endpoint has "end") makes a parser error
  # As a workaround, we define IDENT as any word EXCEPT the reserved words and
  # give priority to IDENT before the reserved words
  # This does not work with current_user because the '_', but I can life without current_user
  IDENT   \b(?!(?:SELECT|DISTINCT|ASC|AS|FROM|WHERE|OFFSET|ROWS|FETCH|FIRST|NEXT|ONLY|BETWEEN|AND|NOT|INNER|INSERT|UPDATE|DELETE|SET|INTO|IN|ORDER|OR|XOR|LIKE|IS|NULL|COUNT|AVG|MAX|MIN|SUM|IFNULL|GROUP|BY|HAVING|CROSS|JOIN|ON|LEFT|OUTER|RIGHT|FULL|USING|EXISTS|DESC|CURRENT_USER|VALUES|LIMIT|OFFSET|CASE|WHEN|THEN|END|ELSE)\b)\w+
  SYMBOL  :\w+

  SQSTR   ([^']|'')*
  DQSTR   ([^"]|"")*

  TRUE   true
  FALSE  false

rule
# [:state]  pattern       [actions]

# literals

            \'            { self.state = :STRS;  [:quote, text] }
  :STRS     \'            { self.state = nil;    [:quote, text] }
  :STRS     {SQSTR}       {                 [:character_string_literal, text.gsub("''", "'")] }
            {TRUE}        { [:true_literal, true] }
            {FALSE}       { [:false_literal, false] }
            \?            { [:variable, text] }
            {SYMBOL}      { [:variable, text] }
            \"            { self.state = :STRD;  [:quote, text] }
  :STRD     \"            { self.state = nil;    [:quote, text] }
  :STRD     {DQSTR}       {                 [:character_string_literal, text.gsub('""', '"')] }

            {UFLOAT}      { [:unsigned_float, text.to_f] }
            {UINT}        { [:unsigned_integer, text.to_i] }

# skip
            {BLANK}       # no action

# identifier
            `{IDENT}`     { [:identifier, text[1..-2]] }
            {IDENT}       { [:identifier, text] }

# keywords
            SELECT        { [:SELECT, text] }
            DISTINCT      { [:DISTINCT, text] }
            ASC           { [:ASC, text] }
            AS            { [:AS, text] }
            FROM          { [:FROM, text] }
            WHERE         { [:WHERE, text] }
            OFFSET        { [:OFFSET, text] }
            ROWS          { [:ROWS, text] }
            FETCH         { [:FETCH, text] }
            FIRST         { [:FIRST, text] }
            NEXT          { [:NEXT, text] }
            ONLY          { [:ONLY, text] }
            BETWEEN       { [:BETWEEN, text] }
            AND           { [:AND, text] }
            NOT           { [:NOT, text] }
            INNER         { [:INNER, text] }
            INSERT        { [:INSERT, text] }
            UPDATE        { [:UPDATE, text] }
            DELETE        { [:DELETE, text] }
            SET           { [:SET, text] }
            INTO          { [:INTO, text] }
            IN            { [:IN, text] }
            ORDER         { [:ORDER, text] }
            OR            { [:OR, text] }
            XOR           { [:XOR, text] }
            LIKE          { [:LIKE, text] }
            IS            { [:IS, text] }
            NULL          { [:NULL, text] }
            COUNT         { [:COUNT, text] }
            AVG           { [:AVG, text] }
            MAX           { [:MAX, text] }
            MIN           { [:MIN, text] }
            SUM           { [:SUM, text] }
            IFNULL        { [:IFNULL, text] }
            GROUP         { [:GROUP, text] }
            BY            { [:BY, text] }
            HAVING        { [:HAVING, text] }
            CROSS         { [:CROSS, text] }
            JOIN          { [:JOIN, text] }
            ON            { [:ON, text] }
            LEFT          { [:LEFT, text] }
            OUTER         { [:OUTER, text] }
            RIGHT         { [:RIGHT, text] }
            FULL          { [:FULL, text] }
            USING         { [:USING, text] }
            EXISTS        { [:EXISTS, text] }
            DESC          { [:DESC, text] }
            CURRENT_USER  { [:CURRENT_USER, text] }
            VALUES        { [:VALUES, text] }
            LIMIT         { [:LIMIT, text] }
            OFFSET        { [:OFFSET, text] }
            CASE          { [:CASE, text] }
            WHEN          { [:WHEN, text] }
            THEN          { [:THEN, text] }
            END           { [:END, text] }
            ELSE          { [:ELSE, text] }

# tokens
            <>            { [:not_equals_operator, text] }
            !=            { [:not_equals_operator, text] }
            =             { [:equals_operator, text] }
            <=            { [:less_than_or_equals_operator, text] }
            <             { [:less_than_operator, text] }
            >=            { [:greater_than_or_equals_operator, text] }
            >             { [:greater_than_operator, text] }

            \(            { [:left_paren, text] }
            \)            { [:right_paren, text] }
            \*            { [:asterisk, text] }
            \/            { [:solidus, text] }
            \+            { [:plus_sign, text] }
            \-            { [:minus_sign, text] }
            \.            { [:period, text] }
            ,             { [:comma, text] }


---- header ----
require 'date'
