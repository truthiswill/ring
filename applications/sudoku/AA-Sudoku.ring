### Program: Sudoku Puzzle
### Author:  Bert Mariani
### Date:    2019-04-30

load "stdlib.ring"
load "guilib.ring"
load "SudokuPuzzles.ring"     ### A File with SUDOKU Puzzles to Solve

###-------------------
### WINDOW SIZE

moveX  = 200 moveY  = 100       ### Open Window on Screen Position
sizeX  = 840 sizeY  = 820       ### Size of Window

hSize = 9   ### Size of array, Display -4 smaller
vSize = 9   ### Size of array, Display -4 smaller
hPos  = 0   ### H-coord of Cell
vPos  = 0   ### V-coord of Cell


###----------------------------------------------------------
### Global so other functions can access the workWidget items

aArray           = null
playArray        = null
aButton          = null
workWidget       = null
gHintArray       = [0,0,0, 0,0,0, 0,0,0, 0,0]	### last 2 are Row-Col

TitletMoves       = null
TitletInvalidMove = null
LayoutButtonRow   = null

comboPuzzleName  = null
puzzleName       = "EnterYourOwn"  ### Default setup

OldRow = 0
OldCol = 0
nMoves = 0
gNbrRightClick = 99 ### RightMouse-SelectMenu-Nbr

aSQColor = [
    [0,0,0, 1,1,1, 0,0,0],
    [0,0,0, 1,1,1, 0,0,0],
    [0,0,0, 1,1,1, 0,0,0],

    [1,1,1, 0,0,0, 1,1,1],
    [1,1,1, 0,0,0, 1,1,1],
    [1,1,1, 0,0,0, 1,1,1],

    [0,0,0, 1,1,1, 0,0,0],
    [0,0,0, 1,1,1, 0,0,0],
    [0,0,0, 1,1,1, 0,0,0] ]

aArray =[
    [0,6,0, 0,0,0, 0,0,7],
    [1,0,7, 0,2,9, 0,0,0],
    [3,2,9, 0,0,0, 8,0,0],

    [0,0,0, 1,0,0, 2,4,0],
    [6,7,8, 0,4,0, 1,9,5],
    [0,1,2, 0,0,6, 0,0,0],

    [0,0,6, 0,0,1, 3,7,9],
    [0,0,0, 6,8,0, 4,0,2],
    [7,0,0, 0,0,0, 0,8,0] ]


playArray = aArray          ### PLAY ARRAY - Record moves etc

aButton = [
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0] ]


dupArray =  [
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0] ]

zeroArray = dupArray

regionArray = [
    [1,1,1, 2,2,2, 3,3,3],
    [1,1,1, 2,2,2, 3,3,3],
    [1,1,1, 2,2,2, 3,3,3],

    [4,4,4, 5,5,5, 6,6,6],
    [4,4,4, 5,5,5, 6,6,6],
    [4,4,4, 5,5,5, 6,6,6],

    [7,7,7, 8,8,8, 9,9,9],
    [7,7,7, 8,8,8, 9,9,9],
    [7,7,7, 8,8,8, 9,9,9] ]

###-------------------------

C_Spacing  = 2
C_ButtonFirstStyle  = 'border-radius:1px; color:black; background-color: rgb(229,249,203) ;'        ### Square pale
C_ButtonSecondStyle = 'border-radius:1px; color:black; background-color: rgb(179,200,93); '         ### Square dark

C_ButtonFirstStyleBlue  = 'border-radius:1px; color:blue; background-color: rgb(229,249,203) ;'        ### Square pale
C_ButtonSecondStyleBlue = 'border-radius:1px; color:blue; background-color: rgb(179,200,93); '         ### Square dark


C_ButtonPickStyle   = 'border-radius:1px; color:black; background-color: rgb(255,255,93); '         ### Yellow
C_ButtonDestStyle   = 'border-radius:1px; color:black; background-color: rgb(204,255,204); '        ### Cyan

C_ButtonPaleStyle   = 'border-radius:1px; color:black; background-color:rgb(255,255,204); '         ### Pale white turn
C_ButtonDarkStyle   = 'border-radius:1px; color:black; background-color:rgb(204,255,255); '         ### Dark black turn

C_ButtonInvalidStyle= 'border-radius:1px; color:black; background-color: rgb(255,102,102); '        ### Light Pink
                       ###'border-style: outset; border-width: 2px; border-radius: 2px; border-color: darkGray; '



###=============================================================================
###=============================================================================
### The shortest app function you ever seen !
### The DrawWidget function does what is normally in this section

app = new qApp
{

    DrawWidget()        ### Draw the Board
    NewGameStart()      ### Initialize the Values
    exec()
}

###---------------------


###=================================================
###=================================================

### FUNCTIONS

###---------------------------------------------------------------------------
### Layout the Grid Square, Create the Arrays
### workWidget items need to be made Global. Mke available toother functions

Func DrawWidget()

    ### Global definition for workWidget

    workWidget = new qWidget()
    {
        setWindowTitle('Sudoku')
        setStyleSheet('background-color:White')

        workHeight = workWidget.height()
        fontSize   = 10 + (workHeight / 100)

        move(moveX, moveY)
        resize(sizeX, sizeY)

        ###----------------------------------------------
        ### Title Top Row - Moves Count

            TitletMoves = new qLineEdit(workWidget)
            {
                #setStyleSheet(C_ButtonDarkStyle)   ### Leave White default
                setFont(new qFont("Calibri",fontsize,100,0))
                setAlignment( Qt_AlignVCenter)
                setAlignment( Qt_AlignVCenter)
                setText(" Filled: "+ nMoves)

            }

            TitletInvalidMove = new qLineEdit(workWidget)
            {
                #setStyleSheet(C_ButtonInvalidStyle)
                setFont(new qFont("Calibri",fontsize,100,0))
                setAlignment( Qt_AlignVCenter)
                setAlignment( Qt_AlignVCenter)
                setText(" Msg ")
            }

            comboPuzzleName = new QComboBox(workWidget)
            {
                setStyleSheet("background-color:White")
                setFont(new qFont("Calibri",fontsize,50,0))
                #aList = ["BoardLayout","Puzzle1","Puzzle2","Puzzle3"]
                aList = PuzzleList                  ### From SudokuPuzzles.ring file
                for x in aList additem(x,0) next
            }

            SolveGame  = new QPushButton(workWidget)
            {
                setStyleSheet(C_ButtonDarkStyle)
                setFont(new qFont("Calibri",fontsize,100,0))
                setText(" Solve ")
                setClickEvent("Solve()")
            }

            NewGame  = new QPushButton(workWidget)
            {
                setStyleSheet("background-color:rgb(255,204,229)")
                setFont(new qFont("Calibri",fontsize,100,0))
                setText(" New Game ")
                setClickEvent("NewGameStart()")
            }

        ###------------------------------------------------

        ###-----------------------------------------------------------------------
        ### QVBoxLayout lays out widgets in a vertical column, from top to bottom.

        ### Vertical
        LayoutButtonMain = new QVBoxLayout()

        LayoutButtonMain.setSpacing(C_Spacing)
        LayoutButtonMain.setContentsMargins(5,5,5,5)


        ### Horizontal - TOP ROW
            LayoutTitleRow = new QHBoxLayout()
            {
                setSpacing(C_Spacing)
                setContentsMargins(0,0,0,0)
            }

            LayoutTitleRow.AddWidget(TitletMoves)
            LayoutTitleRow.AddWidget(TitletInvalidMove)
            LayoutTitleRow.AddWidget(comboPuzzleName)
            LayoutTitleRow.AddWidget(SolveGame)
            LayoutTitleRow.AddWidget(NewGame)

            LayoutButtonMain.AddLayout(LayoutTitleRow)

        ###----------------------------------------------
        ### BUTTON ROWS

        LayoutButtonRow = list(hSize)

        ###---------------------------------------------------------------------
        ### QHBoxLayout lays out widgets in a horizontal row, from left to right

        for Row = 1 to hSize
            LayoutButtonRow[Row] = new QHBoxLayout()    ### Horizontal
            {
                setSpacing(C_Spacing)
                setContentsmargins(0,0,0,0)
            }

            for Col = 1 to vSize
                ###-------------------
                ### Create Buttons

                    aButton[Row][Col] = new QPushButton(workWidget)
                    {
                        value = aSQColor[Row][Col]
                        if value = 1
                            setStyleSheet(C_ButtonFirstStyle)
                        but value = 0
                            setStyleSheet(C_ButtonSecondStyle)
                        else
                            setStyleSheet(C_ButtonInvalidStyle)
                        ok

                        setFont(new qFont("Calibri",fontSize + 10, 100,0))
                        setClickEvent("UserLeftClick(" + string(Row) + "," + string(Col) + ")")
                        setSizePolicy(1,1)          ### Keep SQ size and nbr text proportionate

                            ###-------------------------------------------------
                            ### For Right Mouse Click - does NOT show depression
                            myfilter = new qAllEvents(workWidget)
                            {
                                setContextMenuEvent( "RightClickMouse(" + string(Row) + "," + string(Col) + ")")  ### RIGHT CLICK CELL ===>>>>
                            }
                            installeventfilter(myfilter)
                    }

                ### Widget - Add HORZ BOTTON
                    LayoutButtonRow[Row].AddWidget(aButton[Row][Col])

            next


           ### Layout - Add ROW of BUTTONS
           LayoutButtonMain.AddLayout(LayoutButtonRow[Row])

        next

        ###-------------------------------------------------

        setLayout(LayoutButtonMain)

        show()
    }

return

###============================================================
###

Func RestoreSQColors()

    for Row = 1 to 9
        for Col = 1 to 9

            value = aSQColor[Row][Col]

            value = aSQColor[Row][Col]
            if value = 1

                    if aArray[Row][Col] = 0 AND playArray[Row][Col] >= 1            ### Played Nbr BLUE
                        aButton[Row][Col] {setStyleSheet(C_ButtonFirstStyleBlue)}
                    else
                        aButton[Row][Col] {setStyleSheet(C_ButtonFirstStyle)}       ### Orig   Nbr BLACK
                    ok

            but value = 0

                    if aArray[Row][Col] = 0 AND playArray[Row][Col] >= 1
                        aButton[Row][Col] {setStyleSheet(C_ButtonSecondStyleBlue)}
                    else
                        aButton[Row][Col] {setStyleSheet(C_ButtonSecondStyle)}
                    ok

            else
                aButton[Row][Col] {setStyleSheet(C_ButtonInvalidStyle)}
            ok

        next
    next

return

###============================================================
###

Func NewGameStart()

    ###--------------------------------------------------------
    ### Check User selected which puggle on the Drop-Down List

    puzzleName = comboPuzzleName.currentText()
    See "NewGame: puzzleName: "+ puzzleName +nl

    playArray = zeroArray                   ### Clear previous play
    playArray = WhichPuzzle(puzzleName)     ### From SudokuPuzzle.ring file
    aArray    = playArray


    for Row = 1 to 9
        for Col = 1 to 9

            ###------------------------
            ### Color the SQ Buttons - Dark/Light

            RestoreSQColors()

            ###--------------------------------------------
            ### SQ BUTTONS -- Set NBR/Blank from -aARRAY

            nbr = aArray[Row][Col]
            if nbr = 0
                aButton[Row][Col]{setText("")}
            else
                aButton[Row][Col]{setText(""+ nbr )}
            ok

        next
    next


return

###====================================
### Show GRID array
Func ShowArray(alpha)

    See nl
    for h = 1 to 9
        for v = 1 to 9
            See " "+ alpha[h][v]
        next
        See nl
    next
    See nl
return

###====================================
### Show LINE array
Func ShowArrayLine(alpha)

    //See nl
    for h = 1 to len(alpha)
        See " "+ alpha[h]
    next
    //See nl
return

###====================================
Func UserLeftClick(Row, Col)

    Row = 0+ Row      ### Convert to number
    Col = 0+ Col

    OldRow = Row
    OldCol = Col

	SolveForNumber(Row,Col)		### For This Region, What are the Possible Nbrs that can fit ?
	
    Hint(Row,Col)   ### Show User possible Nbr that do Not Duplicate


return

###=====================================

Func RightClickMouse(Row, Col)

    Row = 0+ Row      ### Convert to number
    Col = 0+ Col
    nbr = 88

    new qMenu(workWidget)
    {
        setStyleSheet("selection-color:black; selection-background-color:cyan;")

        oAction = new qAction(workWidget) { setText("1") setClickEvent("click(1)") }  addAction(oAction)
        oAction = new qAction(workWidget) { setText("2") setClickEvent("click(2)") }  addAction(oAction)
        oAction = new qAction(workWidget) { setText("3") setClickEvent("click(3)") }  addAction(oAction)
        oAction = new qAction(workWidget) { setText("4") setClickEvent("click(4)") }  addAction(oAction)
        oAction = new qAction(workWidget) { setText("5") setClickEvent("click(5)") }  addAction(oAction)
        oAction = new qAction(workWidget) { setText("6") setClickEvent("click(6)") }  addAction(oAction)
        oAction = new qAction(workWidget) { setText("7") setClickEvent("click(7)") }  addAction(oAction)
        oAction = new qAction(workWidget) { setText("8") setClickEvent("click(8)") }  addAction(oAction)
        oAction = new qAction(workWidget) { setText("9") setClickEvent("click(9)") }  addAction(oAction)
        oAction = new qAction(workWidget) { setText("0") setClickEvent("click(0)") }  addAction(oAction)

        oCursor = new qCursor()
        exec(oCursor.pos())
    }

    //See " RightClick: "+ Row +"-"+ Col  +" = "+ gNbrRightClick +nl

    ###--------------------------------------------
    ### Click() function called above RETURNS gNbrRightClick  Here
    ### Insert Nbr in SQ in BLUE

     value = aSQColor[Row][Col]
     if value = 1
         aButton[Row][Col] {setStyleSheet(C_ButtonFirstStyleBlue)  setText(""+ gNbrRightClick ) }
            if gNbrRightClick = 0
                aButton[Row][Col] {setStyleSheet(C_ButtonFirstStyle)  setText("" ) }   ### ERASE SQ when Nbr 0
            ok

     but value = 0
         aButton[Row][Col] {setStyleSheet(C_ButtonSecondStyleBlue) setText(""+ gNbrRightClick ) }
            if gNbrRightClick = 0
                aButton[Row][Col] {setStyleSheet(C_ButtonSecondStyle)  setText("" ) }   ### ERASE SQ when Nbr 0
            ok
     ok


     playArray[Row][Col] = gNbrRightClick       ### PLAY Record Array

     CheckDuplicates(Row,Col)
     CountSQFilled()
     TitletInvalidMove.setText(" Msg:" )        ### Clear HINT Msg from Left-Mouse-Button

return

###=====================================

Func Click(nbr)
    //See "Click: "+ nbr +nl
    gNbrRightClick = nbr

return

###=====================================
### Count Filled SQ - return count

Func CountSQFilled()

    count = 0
    for h = 1 to 9
        for v = 1 to 9
            if playArray[h][v] >= 1
                count++
            ok
        next
    next

    left = 81 - count
    TitletMoves.setText(" Filled: "+ count +" Left: "+ left )

return count

###=====================================------------------
### Check DUPLICATES - Use dupArray to identify  dup SQ
###

Func CheckDuplicates(Row,Col)

    //See "CheckDup: LastPlay: "+Row +"-"+ Col +nl

    dupArray = zeroArray    ### Clear Dups before starting
    RestoreSQColors()       ### Erase Red SQ

    for h = 1 to 9
        CheckDupRow(h)
    next

    for v = 1 to 9
        CheckDupCol(v)
    next

    for r = 1 to 9
        CheckDupRegion(r)
    next

    for h = 1 to 9
        for v = 1 to 9
            if dupArray[h][v] > 1
                 aButton[h][v] {setStyleSheet(C_ButtonInvalidStyle) }
                    ### Last button played
                    aButton[Row][Col] {setStyleSheet(C_ButtonPickStyle) }
            ok
        next
    next

    //ShowArray(dupArray)

return

###=====================================

Func CheckDupRow(Row)

    FlagDup = 0
    nbrCount = [0,0,0,0,0,0,0,0,0]

    ### Find occurrence of a number
    for i = 1 to 9
        nbr = playArray[Row][i]
        if nbr > 0
            nbrCount[nbr] = nbrCount[nbr]++
        ok
    next

    ### Occurrence > 1 goes to dupArray
    for i = 1 to 9
        if nbrCount[i] > 1
            FlagDup = 1
            ### i is the dup nbr value ex. 6
            ### find the 6 in the playArray ... aButton

            for k = 1 to 9
                if playArray[Row][k] = i
                    dupArray[Row][k] = nbrCount[i]
                    //See "DupRow: "+ i +"-"+ Row +" "+ nbrCount[i] +nl
                ok
            next
        ok
    next

return FlagDup

###=====================================
### nbrCount Col: 3
### 0 1 0 0 0 2 1 1 1   <<< Col 3 has 6 twice

Func CheckDupCol(Col)

    FlagDup = 0
    nbrCount = [0,0,0,0,0,0,0,0,0]

    ### Find occurrence of a number
    for i = 1 to 9
        nbr = playArray[i][Col]
        if nbr > 0
            nbrCount[nbr] = nbrCount[nbr]++
        ok
    next

    ### Occurrence > 1 goes to dupArray
    for i = 1 to 9
        if nbrCount[i] > 1
            FlagDup = 1
            ### i is the dup nbr value ex. 6
            ### find the 6 in the playArray ... aButton

            for k = 1 to 9
                if playArray[k][Col] = i
                    dupArray[k][Col] = nbrCount[i]
                    //See "DupCol: "+ i +"-"+ Col +" "+ nbrCount[i] +nl
                ok
            next
        ok
    next

return FlagDup

###=====================================
### Chech for Dup in each of 9 Rgions
### regionArray[
###    [1,1,1,2,2,2,3,3,3],
###    [1,1,1,2,2,2,3,3,3],
###    [1,1,1,2,2,2,3,3,3],
###    [4,4,4,5,5,5,6,6,6],
###    [4,4,4,5,5,5,6,6,6],
###    [4,4,4,5,5,5,6,6,6],
###    [7,7,7,8,8,8,9,9,9],
###    [7,7,7,8,8,8,9,9,9],
###    [7,7,7,8,8,8,9,9,9] ]

Func CheckDupRegion(Region)

    FlagDup = 0
    nbrCount = [0,0,0,0,0,0,0,0,0]

    for h = 1 to 9
        for v = 1 to 9
            if regionArray[h][v] = Region
                nbr = playArray[h][v]

                if nbr > 0
                    nbrCount[nbr] = nbrCount[nbr]++
                ok
            ok
        next
    next

    for h = 1 to 9
        for v = 1 to 9
            if regionArray[h][v] = Region

                for nbr = 1 to 9
                    if nbrCount[nbr] > 1 AND playArray[h][v] = nbr
                        FlagDup = 1
                        dupArray[h][v] = nbrCount[nbr]
                    ok
                next

            ok
        next
    next

return FlagDup

###=================================================================
### Can THIS SQUARE be filled with a NOT Used NBR
###
### 	Show User possible Nbr that do Not Duplicate existing Buttons
### 	User Left-Mouse clicks on a Row-Col
### 	Find possible Nbrs that are NOT-IN  the Row, Col, Region for Square selected

### CALLED BY LEFT_MOUSE BUTTON Click

Func Hint(Row,Col)

    ### For NBR 1 2 3 4 5 6 7 8 9  Increment count if Nbr Exist someplace else
    ### ANY position left with <<0>> is Possible Candidate

    nbrCount = [0,0,0,0,0,0,0,0,0]

    ###----------------
    ### Check this ROW

    for i = 1 to 9
        nbr = playArray[Row][i]
        if nbr > 0
            nbrCount[nbr] = nbrCount[nbr]++
        ok
    next

    ###----------------
    ### Check this Col

    for i = 1 to 9
        nbr = playArray[i][Col]
        if nbr > 0
            nbrCount[nbr] = nbrCount[nbr]++
        ok
    next

    ###-------------------
    ### Check this Region

        RegionID = regionArray[Row][Col]     	### Region-ID 1..9  for SQ in this 
        for h = 1 to 9
            for v = 1 to 9

                curRegion = regionArray[h][v]   ### Current Region are we in for this SQ ?
				
                if curRegion = RegionID      	### Current Region == RegionID of SQ to solve
                    nbr = playArray[h][v]

                    if nbr > 0
                        nbrCount[nbr] = nbrCount[nbr]++
                    ok
                ok
            next
        next

    //See "Hint: " ShowArrayLine(nbrCount)

    ###--------------------------------------------------------------------
    ### HINT MSG: 	Check is ANY Position or Nbr was NOT used --- Still <<0>>
	### 		  	HINT msg created, positions with <<0>> added to msg
	###	gHINTARRAY:	gHintArray: 6-9 = 0 0 3 0 0 0 0 8 0
	
    MsgHint = "Hint:"
			gHintArray = [0,0,0, 0,0,0, 0,0,0, 0,0]	### Zero it out, last 2 are Row-Col			
			gHintArray[10] = Row
			gHintArray[11] = Col
			
			k = 1
			for i = 1 to 9
				if nbrCount[i] = 0                  ### Nbr NOT Used Yet, Add it to Hint msg
					MsgHint = MsgHint +" " + i
					gHintArray[i] = i               ### <<<=== Possible Nbr for this SQ
					k++
				ok
			next
			TitletInvalidMove.setText(MsgHint)
			

    ###-------------------------------------------------------------
    ### CALLED by SOLVE()
    ###     RETURNS  Unique-Nbr value for that Row that Col, that Region
    ###     Is there ONLY ONE possible solution Nbr

    uniqNbr = 0
			k = 0								### k used to count for Unique-Nbr
			for i = 1 to 9
				if nbrCount[i] = 0              ### Nbr Not Used Yet in nbrCount[] position <<0>>
					k++                         ### How many possible nbr found
					uniqNbr = i
				ok
			next

			if k = 1                            ### ONLY ONE - Unique Nbr found
				return uniqNbr                  ### return UniqueNbr value 1..9 else 0 meand NONE found
			ok

return 0

###========================================================
### Solve Puzzle:
###			Scan all the SQuares one by one if a number fits
###					CALL HINT(Row,Col)
###                 UniqNbr returned for Empty SQ  Row-Col-Region
###                 	Insert the Unique nbr return in the Current Row/Col
###
### ... Fill in playArray and aButton
###

### SOLVE BUTTON CLICKED

Func Solve()



	###------------------
	
    for repeat = 1 to 1
        for h = 1 to 9
            for v = 1 to 9

                if playArray[h][v] = 0      ###        Check only SQ that is Empty
                    uniqNbr = Hint(h,v)     ### <<<=== CALL HINT() Is there 1 unique number possible

                    if uniqNbr != 0         ### Yes - Unique-Number returns value 1..9, 0 - NONE
						InsertUniqNbr(h,v,uniqNbr)              
                    ok
                ok
            next
        next

        count = CountSQFilled()
        if count = 81
            TitletInvalidMove.setText(" Msg: FINISHED " )
        ok

    next
	
	###------------------------------------------------------
	### SOLVE FOR NBR ALGO - Fin2 Nbr that Fits the SQuare
	
	for s = 1 to 9 step 3
		for t = 1 to 9 step 3
			SolveForNumber(s,t)
		next
	next

return

###===========================================================
## Insert this Nbr into the SQuare and color SQ same as it was

Func InsertUniqNbr(h,v,uniqNbr)

	playArray[h][v] = uniqNbr

	Value = aSQColor[h][v]		### Value is Button Color
	if Value = 1
			aButton[h][v] {setStyleSheet(C_ButtonFirstStyleBlue)  setText(""+ uniqNbr ) }
	but Value = 0
			aButton[h][v] {setStyleSheet(C_ButtonSecondStyleBlue) setText(""+ uniqNbr ) }
	ok

	//ShowArray(playArray)
return

###============================================================
### For EACH REGION
### 	For EACH SQAURE in the Region
###     	Which Numbers are POSSIBLE for EACH EMPTY SQUARE in the Region
###     	EACH EMPTY SQUARE has 9 possible results in its own Possible Number Array
###		Next
###
###			In the List of  EMPTY SQUARES - Possible Nbr Array
###			Count ALL the Possible Hints
###				if there is a UNIQUE Hint.
###					Identify the SQ Row / Col with ethe Unique nbr
###					Insert it into the Square
###

Func SolveForNumber(Row, Col)

	ThisRow = Row
	ThisCol = Col
	
	RegionForNbr = [
    [0,0,0, 0,0,0, 0,0,0, 0,0],
    [0,0,0, 0,0,0, 0,0,0, 0,0],
    [0,0,0, 0,0,0, 0,0,0, 0,0],
    [0,0,0, 0,0,0, 0,0,0, 0,0],
    [0,0,0, 0,0,0, 0,0,0, 0,0],
    [0,0,0, 0,0,0, 0,0,0, 0,0],
    [0,0,0, 0,0,0, 0,0,0, 0,0],
    [0,0,0, 0,0,0, 0,0,0, 0,0],
    [0,0,0, 0,0,0, 0,0,0, 0,0] ] 	### last 2 are Row-Col
	
	//See "RegionForNbr: "	ShowArray(RegionForNbr) 	See nl
	
	nbrCount = [0,0,0, 0,0,0, 0,0,0]
	
	###-------------------
    ### Check this Region

		//See "Solve For Number ThisRow-ThisCol: "+ThisRow +"-"+ ThisCol +nl
        RegionID = regionArray[ThisRow][ThisCol]     	### Region-ID 1..9  for SQ in this 
		
		k = 1
        for Row = 1 to 9
            for Col = 1 to 9

				###----------------------------------------------------------------------
			    ### Current Region == RegionID of SQ to solve AND playArray SQ is EMPTY
				
                curRegion = regionArray[Row][Col]   		
                if curRegion = RegionID   AND playArray[Row][Col] = 0   		
                    	
					###------------------------------------------------------------	
					### CALL HINT() Fills-In: gHintArray: 6-9 == 0 0 3 0 0 0 0 8 0 
					
					uniqNbr = Hint(Row,Col)     	### Returns Uniq-Nbr if possible
					if uniqNbr != 0         		### Yes - Unique-Number returns value 1..9, 0 - NONE
						InsertUniqNbr(Row,Col,uniqNbr)              
                    ok
					
					//See "gHintArray: "+ Row +"-"+ Col +" -- "  	ShowArrayLine(gHintArray) See nl	

					RegionForNbr[k] = gHintArray
					k++
                ok					
				
            next
        next
		//See nl
		
		//See "After RegionForNbr: "   ShowArray(RegionForNbr)   See nl
		
		### Count EACH-NBR in RegionForNbr position
		### If it occurs ONCE - Insert iton position.
		### nbrCount ==  0 0 3 0 0 1 1 2 0 --  Position = Nbr

			for h = 1 to 9
				for v = 1 to 9      
						nbr = RegionForNbr[h][v] 
						if nbr > 0
							nbrCount[nbr] = nbrCount[nbr]++		###<<<=== 
						ok          
				next
			next
			
			//See nl  ShowArrayLine(nbrCount) See nl
			
		### Find Position =Nbr where the nbrCount values = 1 
		### Then scan RegionForNbrber. Get Row-Col where Position-Nbr occurred
		### Insert the Position-Nbr into the Square
		
			PosNbr = 88
			for k = 1 to 9
				if nbrCount[k] = 1
					PosNbr = k			### Ex. 6
					
					//See "PosNbr: "+ PosNbr 
					
						for h = 1 to 9
							for v = 1 to 9
								if RegionForNbr[h][v] = PosNbr
									GetRow = RegionForNbr[h][10]
									GetCol = RegionForNbr[h][11]
									InsertUniqNbr(GetRow,GetCol,PosNbr)
									
									//See "Found PosNbr: "+ PosNbr +" at "+ GetRow +"-"+GetCol +nl
									exit 2
								ok		
							next
						next
				
				ok
			
			next
	


return

###========================================================





