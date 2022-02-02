'function declarations
DECLARE SUB snd.start ()
DECLARE SUB snd.lohi (low%, high%)
DECLARE SUB snd.freq (freq%)
DECLARE SUB snd.stop ()
DECLARE FUNCTION delay$ (seconds!)
DECLARE FUNCTION delays$ (seconds!)
DECLARE FUNCTION delayf$ (times&)
DECLARE SUB progress (left!)


'word type
TYPE Word
hi AS STRING * 1
lo AS STRING * 1
END TYPE




'handling the pc speaker
'file countdown sound effect
CLS
COLOR 15
PRINT "File Sound"
COLOR 7
PRINT "----------"
PRINT
COLOR 12
PRINT "[w] - increase frequency"
PRINT "[s] - decrease frequency"
PRINT

'get file name
COLOR 14
INPUT "File name"; fsrc$
PRINT
COLOR 12

'default settings
stp% = 10
freq% = 100
time! = 1 / 70
time& = 2000

'prepare
DIM sndWord AS Word
OPEN "B", #1, fsrc$
length& = LOF(1)
left& = length& - (length& AND 1)
snd.start


DO WHILE left& > 0

'play a sound word
GET #1, , sndWord
left& = left& - 2
snd.lohi ASC(sndWord.lo), ASC(sndWord.hi)
k$ = LCASE$(delayf$(time&))


'modify wait
SELECT CASE k$
CASE CHR$(27)
EXIT DO
CASE "w"
time& = time& - 100
IF time& < 100 THEN time& = 100
CASE "s"
time& = time& + 100
CASE ELSE
END SELECT

'show progress
progress left& / length&
LOOP

'end
PRINT
COLOR 7
snd.stop
CLOSE #1

FUNCTION delay$ (seconds!)

FOR lv1% = 0 TO INT(70 * seconds!)
k$ = INKEY$
IF k$ <> "" THEN EXIT FOR
WAIT &H3DA, 8
WAIT &H3DA, 8, 8
NEXT

delay$ = k$
END FUNCTION

FUNCTION delayf$ (times&)

FOR i& = 1 TO times&
k$ = INKEY$
IF k$ <> "" THEN EXIT FOR
NEXT

delayf$ = k$
END FUNCTION

FUNCTION delays$ (seconds!)

tm% = INT(seconds! * 19)
DEF SEG = 0
POKE 1132, 0
DO WHILE (PEEK(1132) < tm%)
k$ = INKEY$
IF k$ <> "" THEN EXIT DO
LOOP
DEF SEG

delays$ = k$
END FUNCTION

SUB progress (left!)

LOCATE CSRLIN, 1
prg% = INT((1 - left!) * 100)
PRINT prg%; "% played";

END SUB

SUB snd.freq (freq%)

'calculate countdown
cnt& = 1193180 \ freq%

'low & high byte of countdown
snd.lohi CINT(cnt& MOD 256), CINT(cnt& \ 256)

END SUB

SUB snd.lohi (low%, high%)

'timer2 <- countdown value
OUT &H43, &HB6
OUT &H42, low%
OUT &H42, high%

END SUB

SUB snd.start

'connect speaker to timer2
val1% = INP(&H61)
val1% = val1% OR 3
OUT &H61, val1%

END SUB

SUB snd.stop

'disconnect speaker from timer2
val1% = INP(&H61)
val1% = val1% AND 252
OUT &H61, val1%

END SUB

