if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'vim') == -1
  
" Vim syntax file
" Language:     Mathematica
" Maintainer:   steve layland <layland@wolfram.com>
" Last Change:  2012 Feb 03 by Thilo Six
" Source:       http://members.wri.com/layland/vim/syntax/mma.vim
"               http://vim.sourceforge.net/scripts/script.php?script_id=1273
" Id:           $Id: mma.vim,v 1.4 2006/04/14 20:40:38 vimboss Exp $
" NOTE:
"
" Empty .m files will automatically be presumed as Matlab files
" unless you have the following in your .vimrc:
"
"       let filetype_m="mma"
"
" I also recommend setting the default 'Comment' hilighting to something
" other than the color used for 'Function', since both are plentiful in
" most mathematica files, and they are often the same color (when using
" background=dark).
"
" Credits:
" o  Original Mathematica syntax version written by
"    Wolfgang Waltenberger <wwalten@ben.tuwien.ac.at>
" o  Some ideas like the CommentStar,CommentTitle were adapted
"    from the Java vim syntax file by Claudio Fleiner.  Thanks!
" o  Everything else written by steve <layland@wolfram.com>
"
" Bugs:
" o  Vim 6.1 didn't really have support for character classes
"    of other named character classes.  For example, [\a\d]
"    didn't work.  Therefore, a lot of this code uses explicit
"    character classes instead: [0-9a-zA-Z]
"
" TODO:
"   folding
"   fix nesting
"   finish populating popular symbols

" quit when a syntax file was already loaded
if exists("b:current_syntax")
    finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Group Definitions:
syntax cluster mmaNotes contains=mmaTodo,mmaFixme
syntax cluster mmaComments contains=mmaComment,mmaFunctionComment,mmaItem,mmaFunctionTitle,mmaCommentStar
syntax cluster mmaCommentStrings contains=mmaLooseQuote,mmaCommentString,mmaUnicode
syntax cluster mmaStrings contains=@mmaCommentStrings,mmaString
syntax cluster mmaTop contains=mmaOperator,mmaGenericFunction,mmaPureFunction,mmaVariable

" Predefined Constants:
"   to list all predefined Symbols would be too insane...
"   it's probably smarter to define a select few, and get the rest from
"   context if absolutely necessary.
"   TODO - populate this with other often used Symbols

" standard fixed symbols:
syntax keyword mmaVariable True False None Automatic All Null C General

" mathematical constants:
syntax keyword mmaVariable Pi I E Infinity ComplexInfinity Indeterminate GoldenRatio EulerGamma Degree Catalan Khinchin Glaisher

" stream data / atomic heads:
syntax keyword mmaVariable Byte Character Expression Number Real String Word EndOfFile Integer Symbol

" sets:
syntax keyword mmaVariable Integers Complexes Reals Booleans Rationals

" character classes:
syntax keyword mmaPattern DigitCharacter LetterCharacter WhitespaceCharacter WordCharacter EndOfString StartOfString EndOfLine StartOfLine WordBoundary

" SelectionMove directions/units:
syntax keyword mmaVariable Next Previous After Before Character Word Expression TextLine CellContents Cell CellGroup EvaluationCell ButtonCell GeneratedCell Notebook
syntax keyword mmaVariable CellTags CellStyle CellLabel

" TableForm positions:
syntax keyword mmaVariable Above Below Left Right

" colors:
syntax keyword mmaVariable Black Blue Brown Cyan Gray Green Magenta Orange Pink Purple Red White Yellow

" function attributes
syntax keyword mmaVariable Protected Listable OneIdentity Orderless Flat Constant NumericFunction Locked ReadProtected HoldFirst HoldRest HoldAll HoldAllComplete SequenceHold NHoldFirst NHoldRest NHoldAll Temporary Stub

" Comment Sections:
"   this:
"   :that:
syntax match mmaItem "\%(^[( |*\t]*\)\@<=\%(:\+\|\w\)\w\+\%( \w\+\)\{0,3}:" contained contains=@mmaNotes

" Comment Keywords:
syntax keyword mmaTodo TODO NOTE HEY contained
syntax match mmaTodo "X\{3,}" contained
syntax keyword mmaFixme FIX[ME] FIXTHIS BROKEN contained
syntax match mmaFixme "BUG\%( *\#\=[0-9]\+\)\=" contained
" yay pirates...
syntax match mmaFixme "\%(Y\=A\+R\+G\+\|GRR\+\|CR\+A\+P\+\)\%(!\+\)\=" contained

" EmPHAsis:
" this unnecessary, but whatever :)
syntax match mmaemPHAsis "\%(^\|\s\)\([_/]\)[a-zA-Z0-9]\+\%([- \t':]\+[a-zA-Z0-9]\+\)*\1\%(\s\|$\)" contained contains=mmaemPHAsis
syntax match mmaemPHAsis "\%(^\|\s\)(\@<!\*[a-zA-Z0-9]\+\%([- \t':]\+[a-zA-Z0-9]\+\)*)\@!\*\%(\s\|$\)" contained contains=mmaemPHAsis

" Regular Comments:
"   (* *)
"   allow nesting (* (* *) *) even though the frontend
"   won't always like it.
syntax region mmaComment start=+(\*+ end=+\*)+ skipempty contains=@mmaNotes,mmaItem,@mmaCommentStrings,mmaemPHAsis,mmaComment

" Function Comments:
"   just like a normal comment except the first sentance is Special ala Java
"   (** *)
"   TODO - fix this for nesting, or not...
syntax region mmaFunctionComment start="(\*\*\+" end="\*\+)" contains=@mmaNotes,mmaItem,mmaFunctionTitle,@mmaCommentStrings,mmaemPHAsis,mmaComment
syntax region mmaFunctionTitle contained matchgroup=mmaFunctionComment start="\%((\*\*[ *]*\)" matchgroup=mmaFunctionTitle keepend end=".[.!-]\=\s*$" end="[.!-][ \t\r<&]"me=e-1 end="\%(\*\+)\)\@=" contained contains=@mmaNotes,mmaItem,mmaCommentStar

" catch remaining (**********)'s
syntax match mmaComment "(\*\*\+)"
" catch preceding *
syntax match mmaCommentStar "^\s*\*\+" contained

" Variables:
"   Dollar sign variables
syntax match mmaVariable "\$\a\+[0-9a-zA-Z$]*"

"   Preceding and Following Contexts
syntax match mmaVariable "`[a-zA-Z$]\+[0-9a-zA-Z$]*" contains=mmaVariable
syntax match mmaVariable "[a-zA-Z$]\+[0-9a-zA-Z$]*`" contains=mmaVariable

" Strings:
"   "string"
"   'string' is not accepted (until literal strings are supported!)
syntax region mmaString start=+\\\@<!"+ skip=+\\\@<!\\\%(\\\\\)*"+ end=+"+
syntax region mmaCommentString oneline start=+\\\@<!"+ skip=+\\\@<!\\\%(\\\\\)*"+ end=+"+ contained


" Patterns:
"   Each pattern marker below can be Blank[] (_), BlankSequence[] (__)
"   or BlankNullSequence[] (___).  Most examples below can also be
"   combined, for example Pattern tests with Default values.
"
"   _Head                   Anonymous patterns
"   name_Head
"   name:(_Head|_Head2)     Named patterns
"
"   _Head : val
"   name:_Head:val          Default values
"
"   _Head?testQ,
"   _Head?(test[#]&)        Pattern tests
"
"   name_Head/;test[name]   Conditionals
"
"   _Head:.                 Predefined Default
"
"   .. ...                  Pattern Repeat

syntax match mmaPatternError "\%(_\{4,}\|)\s*&\s*)\@!\)" contained

"pattern name:
syntax match mmaPattern "[A-Za-z0-9`]\+\s*:\+[=>]\@!" contains=mmaOperator
"pattern default:
syntax match mmaPattern ": *[^ ,]\+[\], ]\@=" contains=@mmaCommentStrings,@mmaTop,mmaOperator
"pattern head/test:
syntax match mmaPattern "[A-Za-z0-9`]*_\+\%(\a\+\)\=\%(?([^)]\+)\|?[^\]},]\+\)\=" contains=@mmaTop,@mmaCommentStrings,mmaPatternError

" Operators:
"   /: ^= ^:=   UpValue
"   /;          Conditional
"   := =        DownValue
"   == === ||
"   != =!= &&   Logic
"   >= <= < >
"   += -= *=
"   /= ++ --    Math
"   ^*
"   -> :>       Rules
"   @@ @@@      Apply
"   /@ //@      Map
"   /. //.      Replace
"   // @        Function application
"   <> ~~       String/Pattern join
"   ~           infix operator
"   . :         Pattern operators
syntax match mmaOperator "\%(@\{1,3}\|//[.@]\=\)"
syntax match mmaOperator "\%(/[;:@.]\=\|\^\=:\==\)"
syntax match mmaOperator "\%([-:=]\=>\|<=\=\)"
"syntax match mmaOperator "\%(++\=\|--\=\|[/+-*]=\|[^*]\)"
syntax match mmaOperator "[*+=^.:?-]"
syntax match mmaOperator "\%(\~\~\=\)"
syntax match mmaOperator "\%(=\{2,3}\|=\=!=\|||\=\|&&\|!\)" contains=ALLBUT,mmaPureFunction

" Symbol Tags:
"   "SymbolName::item"
"syntax match mmaSymbol "`\=[a-zA-Z$]\+[0-9a-zA-Z$]*\%(`\%([a-zA-Z$]\+[0-9a-zA-Z$]*\)\=\)*" contained
syntax match mmaMessage "`\=\([a-zA-Z$]\+[0-9a-zA-Z$]*\)\%(`\%([a-zA-Z$]\+[0-9a-zA-Z$]*\)\=\)*::\a\+" contains=mmaMessageType
syntax match mmaMessageType "::\a\+"hs=s+2 contained

" Pure Functions:
syntax match mmaPureFunction "#\%(#\|\d\+\)\="
syntax match mmaPureFunction "&"

" Named Functions:
" Since everything is pretty much a function, get this straight
" from context
syntax match mmaGenericFunction "[A-Za-z0-9`]\+\s*\%([@[]\|/:\|/\=/@\)\@=" contains=mmaOperator
syntax match mmaGenericFunction "\~\s*[^~]\+\s*\~"hs=s+1,he=e-1 contains=mmaOperator,mmaBoring
syntax match mmaGenericFunction "//\s*[A-Za-z0-9`]\+"hs=s+2 contains=mmaOperator

" Numbers:
syntax match mmaNumber "\<\%(\d\+\.\=\d*\|\d*\.\=\d\+\)\>"
syntax match mmaNumber "`\d\+\%(\d\@!\.\|\>\)"

" Special Characters:
"   \[Name]     named character
"   \ooo        octal
"   \.xx        2 digit hex
"   \:xxxx      4 digit hex (multibyte unicode)
syntax match mmaUnicode "\\\[\w\+\d*\]"
syntax match mmaUnicode "\\\%(\x\{3}\|\.\x\{2}\|:\x\{4}\)"

" Syntax Errors:
syntax match mmaError "\*)" containedin=ALLBUT,@mmaComments,@mmaStrings
syntax match mmaError "\%([/]{3,}\|[&:|+*?~-]\{3,}\|[.=]\{4,}\|_\@<=\.\{2,}\|`\{2,}\)" containedin=ALLBUT,@mmaComments,@mmaStrings

" Punctuation:
" things that shouldn't really be highlighted, or highlighted
" in they're own group if you _really_ want. :)
"  ( ) { }
" TODO - use Delimiter group?
syntax match mmaBoring "[(){}]" contained

" ------------------------------------
"    future explorations...
" ------------------------------------
" Function Arguments:
"   anything between brackets []
"   (fold)
"syntax region mmaArgument start="\[" end="\]" containedin=ALLBUT,@mmaComments,@mmaStrings transparent fold

" Lists:
"   (fold)
"syntax region mmaLists start="{" end="}" containedin=ALLBUT,@mmaComments,@mmaStrings transparent fold

" Regions:
"   (fold)
"syntax region mmaRegion start="(\*\+[^<]*<!--[^>]*\*\+)" end="--> \*)" containedin=ALLBUT,@mmaStrings transparent fold keepend

" show fold text
set commentstring='(*%s*)'
"set foldtext=MmaFoldText()

"function MmaFoldText()
"    let line = getline(v:foldstart)
"
"    let lines = v:foldend-v:foldstart+1
"
"    let sub = substitute(line, '(\*\+|\*\+)|[-*_]\+', '', 'g')
"
"    if match(line, '(\*') != -1
"        let lines = lines.' line comment'
"    else
"        let lines = lines.' lines'
"    endif
"
"    return v:folddashes.' '.lines.' '.sub
"endf

"this is slow for computing folds, but it does so accurately
syntax sync fromstart

" but this seems to do alright for non fold syntax coloring.
" for folding, however, it doesn't get the nesting right.
" TODO - find sync group for multiline modules? ick...

" sync multi line comments
"syntax sync match syncComments groupthere NONE "\*)"
"syntax sync match syncComments groupthere mmaComment "(\*"

"set foldmethod=syntax
"set foldnestmax=1
"set foldminlines=15


" NOTE - the following links are not guaranteed to
" look good under all colorschemes.  You might need to
" :so $VIMRUNTIME/syntax/hitest.vim and tweak these to
" look good in yours


hi def link mmaComment           Comment
hi def link mmaCommentStar       Comment
hi def link mmaFunctionComment   Comment
hi def link mmaLooseQuote        Comment
hi def link mmaGenericFunction   Function
hi def link mmaVariable          Identifier
"    hi def link mmaSymbol            Identifier
hi def link mmaOperator          Operator
hi def link mmaPatternOp         Operator
hi def link mmaPureFunction      Operator
hi def link mmaString            String
hi def link mmaCommentString     String
hi def link mmaUnicode           String
hi def link mmaMessage           Type
hi def link mmaNumber            Type
hi def link mmaPattern           Type
hi def link mmaError             Error
hi def link mmaFixme             Error
hi def link mmaPatternError      Error
hi def link mmaTodo              Todo
hi def link mmaemPHAsis          Special
hi def link mmaFunctionTitle     Special
hi def link mmaMessageType       Special
hi def link mmaItem              Preproc


let b:current_syntax = "mma"

let &cpo = s:cpo_save
unlet s:cpo_save

endif
if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'mathematica') == -1
  
"Vim syntax file
" Language: Mathematica
" Maintainer: R. Menon <rsmenon@icloud.com>
" Last Change: Feb 25, 2013

if exists("b:current_syntax")
    finish
endif

let s:cpo_save = &cpo
set cpo&vim

syntax case match
setlocal iskeyword+=`,$
setlocal iskeyword-=:,-
"
"Functions in the System` context as of 9.0.1
syntax keyword mmaSystemSymbol AbelianGroup Abort AbortKernels AbortProtect Above Abs Absolute AbsoluteCorrelation AbsoluteCorrelationFunction AbsoluteCurrentValue AbsoluteDashing AbsoluteFileName AbsoluteOptions AbsolutePointSize AbsoluteThickness AbsoluteTime AbsoluteTiming AccountingForm Accumulate Accuracy AccuracyGoal ActionDelay ActionMenu ActionMenuBox ActionMenuBoxOptions Active ActiveItem ActiveStyle AcyclicGraphQ AddOnHelpPath AddTo AdjacencyGraph AdjacencyList AdjacencyMatrix AdjustmentBox AdjustmentBoxOptions AdjustTimeSeriesForecast AffineTransform After AiryAi AiryAiPrime AiryAiZero AiryBi AiryBiPrime AiryBiZero AlgebraicIntegerQ AlgebraicNumber AlgebraicNumberDenominator AlgebraicNumberNorm AlgebraicNumberPolynomial AlgebraicNumberTrace AlgebraicRules AlgebraicRulesData Algebraics AlgebraicUnitQ Alignment AlignmentMarker AlignmentPoint All AllowedDimensions AllowGroupClose AllowInlineCells AllowKernelInitialization AllowReverseGroupClose AllowScriptLevelChange AlphaChannel AlternatingGroup AlternativeHypothesis Alternatives AmbientLight Analytic AnchoredSearch And AndersonDarlingTest AngerJ AngleBracket AngularGauge Animate AnimationCycleOffset AnimationCycleRepetitions AnimationDirection AnimationDisplayTime AnimationRate AnimationRepetitions AnimationRunning Animator AnimatorBox AnimatorBoxOptions AnimatorElements Annotation Annuity AnnuityDue Antialiasing Antisymmetric Apart ApartSquareFree Appearance AppearanceElements AppellF1 Append AppendTo Apply ArcCos ArcCosh ArcCot ArcCoth ArcCsc ArcCsch ArcSec ArcSech ArcSin ArcSinDistribution ArcSinh ArcTan ArcTanh Arg ArgMax ArgMin ArgumentCountQ ARIMAProcess ArithmeticGeometricMean ARMAProcess ARProcess Array ArrayComponents ArrayDepth ArrayFlatten ArrayPad ArrayPlot ArrayQ ArrayReshape ArrayRules Arrays Arrow Arrow3DBox ArrowBox Arrowheads AspectRatio AspectRatioFixed Assert Assuming Assumptions AstronomicalData Asynchronous AsynchronousTaskObject AsynchronousTasks AtomQ Attributes AugmentedSymmetricPolynomial AutoAction AutoDelete AutoEvaluateEvents AutoGeneratedPackage AutoIndent AutoIndentSpacings AutoItalicWords AutoloadPath AutoMatch Automatic AutomaticImageSize AutoMultiplicationSymbol AutoNumberFormatting AutoOpenNotebooks AutoOpenPalettes AutorunSequencing AutoScaling AutoScroll AutoSpacing AutoStyleOptions AutoStyleWords Axes AxesEdge AxesLabel AxesOrigin AxesStyle Axis
syntax keyword mmaSystemSymbol BabyMonsterGroupB Back Background BackgroundTasksSettings Backslash Backsubstitution Backward Band BandpassFilter BandstopFilter BarabasiAlbertGraphDistribution BarChart BarChart3D BarLegend BarlowProschanImportance BarnesG BarOrigin BarSpacing BartlettHannWindow BartlettWindow BaseForm Baseline BaselinePosition BaseStyle BatesDistribution BattleLemarieWavelet Because BeckmannDistribution Beep Before Begin BeginDialogPacket BeginFrontEndInteractionPacket BeginPackage BellB BellY Below BenfordDistribution BeniniDistribution BenktanderGibratDistribution BenktanderWeibullDistribution BernoulliB BernoulliDistribution BernoulliGraphDistribution BernoulliProcess BernsteinBasis BesselFilterModel BesselI BesselJ BesselJZero BesselK BesselY BesselYZero Beta BetaBinomialDistribution BetaDistribution BetaNegativeBinomialDistribution BetaPrimeDistribution BetaRegularized BetweennessCentrality BezierCurve BezierCurve3DBox BezierCurve3DBoxOptions BezierCurveBox BezierCurveBoxOptions BezierFunction BilateralFilter Binarize BinaryFormat BinaryImageQ BinaryRead BinaryReadList BinaryWrite BinCounts BinLists Binomial BinomialDistribution BinomialProcess BinormalDistribution BiorthogonalSplineWavelet BipartiteGraphQ BirnbaumImportance BirnbaumSaundersDistribution BitAnd BitClear BitGet BitLength BitNot BitOr BitSet BitShiftLeft BitShiftRight BitXor Black BlackmanHarrisWindow BlackmanNuttallWindow BlackmanWindow Blank BlankForm BlankNullSequence BlankSequence Blend Block BlockRandom BlomqvistBeta BlomqvistBetaTest Blue Blur BodePlot BohmanWindow Bold Bookmarks Boole BooleanConsecutiveFunction BooleanConvert BooleanCountingFunction BooleanFunction BooleanGraph BooleanMaxterms BooleanMinimize BooleanMinterms Booleans BooleanTable BooleanVariables BorderDimensions BorelTannerDistribution Bottom BottomHatTransform BoundaryStyle Bounds Box BoxBaselineShift BoxData BoxDimensions Boxed Boxes BoxForm BoxFormFormatTypes BoxFrame BoxID BoxMargins BoxMatrix BoxRatios BoxRotation BoxRotationPoint BoxStyle BoxWhiskerChart Bra BracketingBar BraKet BrayCurtisDistance BreadthFirstScan Break Brown BrownForsytheTest BrownianBridgeProcess BrowserCategory BSplineBasis BSplineCurve BSplineCurve3DBox BSplineCurveBox BSplineCurveBoxOptions BSplineFunction BSplineSurface BSplineSurface3DBox BubbleChart BubbleChart3D BubbleScale BubbleSizes BulletGauge BusinessDayQ ButterflyGraph ButterworthFilterModel Button ButtonBar ButtonBox ButtonBoxOptions ButtonCell ButtonContents ButtonData ButtonEvaluator ButtonExpandable ButtonFrame ButtonFunction ButtonMargins ButtonMinHeight ButtonNote ButtonNotebook ButtonSource ButtonStyle ButtonStyleMenuListing Byte ByteCount ByteOrdering
syntax keyword mmaSystemSymbol C CachedValue CacheGraphics CalendarData CalendarType CallPacket CanberraDistance Cancel CancelButton CandlestickChart Cap CapForm CapitalDifferentialD CardinalBSplineBasis CarmichaelLambda Cases Cashflow Casoratian Catalan CatalanNumber Catch CauchyDistribution CauchyWindow CayleyGraph CDF CDFDeploy CDFInformation CDFWavelet Ceiling Cell CellAutoOverwrite CellBaseline CellBoundingBox CellBracketOptions CellChangeTimes CellContents CellContext CellDingbat CellDynamicExpression CellEditDuplicate CellElementsBoundingBox CellElementSpacings CellEpilog CellEvaluationDuplicate CellEvaluationFunction CellEventActions CellFrame CellFrameColor CellFrameLabelMargins CellFrameLabels CellFrameMargins CellGroup CellGroupData CellGrouping CellGroupingRules CellHorizontalScrolling CellID CellLabel CellLabelAutoDelete CellLabelMargins CellLabelPositioning CellMargins CellObject CellOpen CellPrint CellProlog Cells CellSize CellStyle CellTags CellularAutomaton CensoredDistribution Censoring Center CenterDot CentralMoment CentralMomentGeneratingFunction CForm ChampernowneNumber ChanVeseBinarize Character CharacterEncoding CharacterEncodingsPath CharacteristicFunction CharacteristicPolynomial CharacterRange Characters ChartBaseStyle ChartElementData ChartElementDataFunction ChartElementFunction ChartElements ChartLabels ChartLayout ChartLegends ChartStyle Chebyshev1FilterModel Chebyshev2FilterModel ChebyshevDistance ChebyshevT ChebyshevU Check CheckAbort CheckAll Checkbox CheckboxBar CheckboxBox CheckboxBoxOptions ChemicalData ChessboardDistance ChiDistribution ChineseRemainder ChiSquareDistribution ChoiceButtons ChoiceDialog CholeskyDecomposition Chop Circle CircleBox CircleDot CircleMinus CirclePlus CircleTimes CirculantGraph CityData Clear ClearAll ClearAttributes ClearSystemCache ClebschGordan ClickPane Clip ClipboardNotebook ClipFill ClippingStyle ClipPlanes ClipRange Clock ClockGauge ClockwiseContourIntegral Close Closed CloseKernels ClosenessCentrality Closing ClosingAutoSave ClosingEvent ClusteringComponents CMYKColor Coarse Coefficient CoefficientArrays CoefficientDomain CoefficientList CoefficientRules CoifletWavelet Collect Colon ColonForm ColorCombine ColorConvert ColorData ColorDataFunction ColorFunction ColorFunctionScaling Colorize ColorNegate ColorOutput ColorProfileData ColorQuantize ColorReplace ColorRules ColorSelectorSettings ColorSeparate ColorSetter ColorSetterBox ColorSetterBoxOptions ColorSlider ColorSpace Column ColumnAlignments ColumnBackgrounds ColumnForm ColumnLines ColumnsEqual ColumnSpacings ColumnWidths CommonDefaultFormatTypes Commonest CommonestFilter CommonUnits CommunityBoundaryStyle CommunityGraphPlot CommunityLabels CommunityRegionStyle CompatibleUnitQ CompilationOptions CompilationTarget Compile Compiled CompiledFunction Complement CompleteGraph CompleteGraphQ CompleteKaryTree CompletionsListPacket Complex Complexes ComplexExpand ComplexInfinity ComplexityFunction ComponentMeasurements
syntax keyword mmaSystemSymbol ComponentwiseContextMenu Compose ComposeList ComposeSeries Composition CompoundExpression CompoundPoissonDistribution CompoundPoissonProcess CompoundRenewalProcess Compress CompressedData Condition ConditionalExpression Conditioned Cone ConeBox ConfidenceLevel ConfidenceRange ConfidenceTransform ConfigurationPath Congruent Conjugate ConjugateTranspose Conjunction Connect ConnectedComponents ConnectedGraphQ ConnesWindow ConoverTest ConsoleMessage ConsoleMessagePacket ConsolePrint Constant ConstantArray Constants ConstrainedMax ConstrainedMin ContentPadding ContentsBoundingBox ContentSelectable ContentSize Context ContextMenu Contexts ContextToFilename ContextToFileName Continuation Continue ContinuedFraction ContinuedFractionK ContinuousAction ContinuousMarkovProcess ContinuousTimeModelQ ContinuousWaveletData ContinuousWaveletTransform ContourDetect ContourGraphics ContourIntegral ContourLabels ContourLines ContourPlot ContourPlot3D Contours ContourShading ContourSmoothing ContourStyle ContraharmonicMean Control ControlActive ControlAlignment ControllabilityGramian ControllabilityMatrix ControllableDecomposition ControllableModelQ ControllerDuration ControllerInformation ControllerInformationData ControllerLinking ControllerManipulate ControllerMethod ControllerPath ControllerState ControlPlacement ControlsRendering ControlType Convergents ConversionOptions ConversionRules ConvertToBitmapPacket ConvertToPostScript ConvertToPostScriptPacket Convolve ConwayGroupCo1 ConwayGroupCo2 ConwayGroupCo3 CoordinateChartData CoordinatesToolOptions CoordinateTransform CoordinateTransformData CoprimeQ Coproduct CopulaDistribution Copyable CopyDirectory CopyFile CopyTag CopyToClipboard CornerFilter CornerNeighbors Correlation CorrelationDistance CorrelationFunction CorrelationTest Cos Cosh CoshIntegral CosineDistance CosineWindow CosIntegral Cot Coth Count CounterAssignments CounterBox CounterBoxOptions CounterClockwiseContourIntegral CounterEvaluator CounterFunction CounterIncrements CounterStyle CounterStyleMenuListing CountRoots CountryData Covariance CovarianceEstimatorFunction CovarianceFunction CoxianDistribution CoxIngersollRossProcess CoxModel CoxModelFit CramerVonMisesTest CreateArchive CreateDialog CreateDirectory CreateDocument CreateIntermediateDirectories CreatePalette CreatePalettePacket CreateScheduledTask CreateTemporary CreateWindow CriticalityFailureImportance CriticalitySuccessImportance CriticalSection Cross CrossingDetect CrossMatrix Csc Csch CubeRoot Cubics Cuboid CuboidBox Cumulant CumulantGeneratingFunction Cup CupCap Curl CurlyDoubleQuote CurlyQuote CurrentImage CurrentlySpeakingPacket CurrentValue CurvatureFlowFilter CurveClosed Cyan CycleGraph CycleIndexPolynomial Cycles CyclicGroup Cyclotomic Cylinder CylinderBox CylindricalDecomposition
syntax keyword mmaSystemSymbol D DagumDistribution DamerauLevenshteinDistance DampingFactor Darker Dashed Dashing DataCompression DataDistribution DataRange DataReversed Date DateDelimiters DateDifference DateFunction DateList DateListLogPlot DateListPlot DatePattern DatePlus DateRange DateString DateTicksFormat DaubechiesWavelet DavisDistribution DawsonF DayCount DayCountConvention DayMatchQ DayName DayPlus DayRange DayRound DeBruijnGraph Debug DebugTag Decimal DeclareKnownSymbols DeclarePackage Decompose Decrement DedekindEta Default DefaultAxesStyle DefaultBaseStyle DefaultBoxStyle DefaultButton DefaultColor DefaultControlPlacement DefaultDuplicateCellStyle DefaultDuration DefaultElement DefaultFaceGridsStyle DefaultFieldHintStyle DefaultFont DefaultFontProperties DefaultFormatType DefaultFormatTypeForStyle DefaultFrameStyle DefaultFrameTicksStyle DefaultGridLinesStyle DefaultInlineFormatType DefaultInputFormatType DefaultLabelStyle DefaultMenuStyle DefaultNaturalLanguage DefaultNewCellStyle DefaultNewInlineCellStyle DefaultNotebook DefaultOptions DefaultOutputFormatType DefaultStyle DefaultStyleDefinitions DefaultTextFormatType DefaultTextInlineFormatType DefaultTicksStyle DefaultTooltipStyle DefaultValues Defer DefineExternal DefineInputStreamMethod DefineOutputStreamMethod Definition Degree DegreeCentrality DegreeGraphDistribution DegreeLexicographic DegreeReverseLexicographic Deinitialization Del Deletable Delete DeleteBorderComponents DeleteCases DeleteContents DeleteDirectory DeleteDuplicates DeleteFile DeleteSmallComponents DeleteWithContents DeletionWarning Delimiter DelimiterFlashTime DelimiterMatching Delimiters Denominator DensityGraphics DensityHistogram DensityPlot DependentVariables Deploy Deployed Depth DepthFirstScan Derivative DerivativeFilter DescriptorStateSpace DesignMatrix Det DGaussianWavelet DiacriticalPositioning Diagonal DiagonalMatrix Dialog DialogIndent DialogInput DialogLevel DialogNotebook DialogProlog DialogReturn DialogSymbols Diamond DiamondMatrix DiceDissimilarity DictionaryLookup DifferenceDelta DifferenceOrder DifferenceRoot DifferenceRootReduce Differences DifferentialD DifferentialRoot DifferentialRootReduce DifferentiatorFilter DigitBlock DigitBlockMinimum DigitCharacter DigitCount DigitQ DihedralGroup Dilation Dimensions DiracComb DiracDelta DirectedEdge DirectedEdges DirectedGraph DirectedGraphQ DirectedInfinity Direction Directive Directory DirectoryName DirectoryQ DirectoryStack DirichletCharacter DirichletConvolve DirichletDistribution DirichletL DirichletTransform DirichletWindow DisableConsolePrintPacket DiscreteChirpZTransform DiscreteConvolve DiscreteDelta DiscreteHadamardTransform DiscreteIndicator DiscreteLQEstimatorGains DiscreteLQRegulatorGains DiscreteLyapunovSolve DiscreteMarkovProcess DiscretePlot DiscretePlot3D DiscreteRatio DiscreteRiccatiSolve DiscreteShift DiscreteTimeModelQ DiscreteUniformDistribution DiscreteVariables DiscreteWaveletData DiscreteWaveletPacketTransform
syntax keyword mmaSystemSymbol DiscreteWaveletTransform Discriminant Disjunction Disk DiskBox DiskMatrix Dispatch DispersionEstimatorFunction Display DisplayAllSteps DisplayEndPacket DisplayFlushImagePacket DisplayForm DisplayFunction DisplayPacket DisplayRules DisplaySetSizePacket DisplayString DisplayTemporary DisplayWith DisplayWithRef DisplayWithVariable DistanceFunction DistanceTransform Distribute Distributed DistributedContexts DistributeDefinitions DistributionChart DistributionDomain DistributionFitTest DistributionParameterAssumptions DistributionParameterQ Dithering Div Divergence Divide DivideBy Dividers Divisible Divisors DivisorSigma DivisorSum DMSList DMSString Do DockedCells DocumentNotebook DominantColors DOSTextFormat Dot DotDashed DotEqual Dotted DoubleBracketingBar DoubleContourIntegral DoubleDownArrow DoubleLeftArrow DoubleLeftRightArrow DoubleLeftTee DoubleLongLeftArrow DoubleLongLeftRightArrow DoubleLongRightArrow DoubleRightArrow DoubleRightTee DoubleUpArrow DoubleUpDownArrow DoubleVerticalBar DoublyInfinite Down DownArrow DownArrowBar DownArrowUpArrow DownLeftRightVector DownLeftTeeVector DownLeftVector DownLeftVectorBar DownRightTeeVector DownRightVector DownRightVectorBar Downsample DownTee DownTeeArrow DownValues DragAndDrop DrawEdges DrawFrontFaces DrawHighlighted Drop DSolve Dt DualLinearProgramming DualSystemsModel DumpGet DumpSave DuplicateFreeQ Dynamic DynamicBox DynamicBoxOptions DynamicEvaluationTimeout DynamicLocation DynamicModule DynamicModuleBox DynamicModuleBoxOptions DynamicModuleParent DynamicModuleValues DynamicName DynamicNamespace DynamicReference DynamicSetting DynamicUpdating DynamicWrapper DynamicWrapperBox DynamicWrapperBoxOptions
syntax keyword mmaSystemSymbol E EccentricityCentrality EdgeAdd EdgeBetweennessCentrality EdgeCapacity EdgeCapForm EdgeColor EdgeConnectivity EdgeCost EdgeCount EdgeCoverQ EdgeDashing EdgeDelete EdgeDetect EdgeForm EdgeIndex EdgeJoinForm EdgeLabeling EdgeLabels EdgeLabelStyle EdgeList EdgeOpacity EdgeQ EdgeRenderingFunction EdgeRules EdgeShapeFunction EdgeStyle EdgeThickness EdgeWeight Editable EditButtonSettings EditCellTagsSettings EditDistance EffectiveInterest Eigensystem Eigenvalues EigenvectorCentrality Eigenvectors Element ElementData Eliminate EliminationOrder EllipticE EllipticExp EllipticExpPrime EllipticF EllipticFilterModel EllipticK EllipticLog EllipticNomeQ EllipticPi EllipticReducedHalfPeriods EllipticTheta EllipticThetaPrime EmitSound EmphasizeSyntaxErrors EmpiricalDistribution Empty EmptyGraphQ EnableConsolePrintPacket Enabled Encode End EndAdd EndDialogPacket EndFrontEndInteractionPacket EndOfFile EndOfLine EndOfString EndPackage EngineeringForm Enter EnterExpressionPacket EnterTextPacket Entropy EntropyFilter Environment Epilog Equal EqualColumns EqualRows EqualTilde EquatedTo Equilibrium EquirippleFilterKernel Equivalent Erf Erfc Erfi ErlangB ErlangC ErlangDistribution Erosion ErrorBox ErrorBoxOptions ErrorNorm ErrorPacket ErrorsDialogSettings EstimatedDistribution EstimatedProcess EstimatorGains EstimatorRegulator EuclideanDistance EulerE EulerGamma EulerianGraphQ EulerPhi Evaluatable Evaluate Evaluated EvaluatePacket EvaluationCell EvaluationCompletionAction EvaluationElements EvaluationMode EvaluationMonitor EvaluationNotebook EvaluationObject EvaluationOrder Evaluator EvaluatorNames EvenQ EventData EventEvaluator EventHandler EventHandlerTag EventLabels ExactBlackmanWindow ExactNumberQ ExactRootIsolation ExampleData Except ExcludedForms ExcludePods Exclusions ExclusionsStyle Exists Exit ExitDialog Exp Expand ExpandAll ExpandDenominator ExpandFileName ExpandNumerator Expectation ExpectationE ExpectedValue ExpGammaDistribution ExpIntegralE ExpIntegralEi Exponent ExponentFunction ExponentialDistribution ExponentialFamily ExponentialGeneratingFunction ExponentialMovingAverage ExponentialPowerDistribution ExponentPosition ExponentStep Export ExportAutoReplacements ExportPacket ExportString Expression ExpressionCell ExpressionPacket ExpToTrig ExtendedGCD Extension ExtentElementFunction ExtentMarkers ExtentSize ExternalCall ExternalDataCharacterEncoding Extract ExtractArchive ExtremeValueDistribution
syntax keyword mmaSystemSymbol FaceForm FaceGrids FaceGridsStyle Factor FactorComplete Factorial Factorial2 FactorialMoment FactorialMomentGeneratingFunction FactorialPower FactorInteger FactorList FactorSquareFree FactorSquareFreeList FactorTerms FactorTermsList Fail FailureDistribution False FARIMAProcess FEDisableConsolePrintPacket FeedbackSector FeedbackSectorStyle FeedbackType FEEnableConsolePrintPacket Fibonacci FieldHint FieldHintStyle FieldMasked FieldSize File FileBaseName FileByteCount FileDate FileExistsQ FileExtension FileFormat FileHash FileInformation FileName FileNameDepth FileNameDialogSettings FileNameDrop FileNameJoin FileNames FileNameSetter FileNameSplit FileNameTake FilePrint FileType FilledCurve FilledCurveBox Filling FillingStyle FillingTransform FilterRules FinancialBond FinancialData FinancialDerivative FinancialIndicator Find FindArgMax FindArgMin FindClique FindClusters FindCurvePath FindDistributionParameters FindDivisions FindEdgeCover FindEdgeCut FindEulerianCycle FindFaces FindFile FindFit FindGeneratingFunction FindGeoLocation FindGeometricTransform FindGraphCommunities FindGraphIsomorphism FindGraphPartition FindHamiltonianCycle FindIndependentEdgeSet FindIndependentVertexSet FindInstance FindIntegerNullVector FindKClan FindKClique FindKClub FindKPlex FindLibrary FindLinearRecurrence FindList FindMaximum FindMaximumFlow FindMaxValue FindMinimum FindMinimumCostFlow FindMinimumCut FindMinValue FindPermutation FindPostmanTour FindProcessParameters FindRoot FindSequenceFunction FindSettings FindShortestPath FindShortestTour FindThreshold FindVertexCover FindVertexCut Fine FinishDynamic FiniteAbelianGroupCount FiniteGroupCount FiniteGroupData First FirstPassageTimeDistribution FischerGroupFi22 FischerGroupFi23 FischerGroupFi24Prime FisherHypergeometricDistribution FisherRatioTest FisherZDistribution Fit FitAll FittedModel FixedPoint FixedPointList FlashSelection Flat Flatten FlattenAt FlatTopWindow FlipView Floor FlushPrintOutputPacket Fold FoldList Font FontColor FontFamily FontForm FontName FontOpacity FontPostScriptName FontProperties FontReencoding FontSize FontSlant FontSubstitutions FontTracking FontVariations FontWeight For ForAll Format FormatRules FormatType FormatTypeAutoConvert FormatValues FormBox FormBoxOptions FortranForm Forward ForwardBackward Fourier FourierCoefficient FourierCosCoefficient FourierCosSeries FourierCosTransform FourierDCT FourierDCTFilter FourierDCTMatrix FourierDST FourierDSTMatrix FourierMatrix FourierParameters FourierSequenceTransform FourierSeries FourierSinCoefficient FourierSinSeries FourierSinTransform FourierTransform FourierTrigSeries FractionalBrownianMotionProcess FractionalPart FractionBox FractionBoxOptions FractionLine Frame FrameBox FrameBoxOptions Framed FrameInset FrameLabel Frameless FrameMargins FrameStyle FrameTicks FrameTicksStyle FRatioDistribution FrechetDistribution FreeQ FrequencySamplingFilterKernel FresnelC FresnelS Friday FrobeniusNumber FrobeniusSolve
syntax keyword mmaSystemSymbol FromCharacterCode FromCoefficientRules FromContinuedFraction FromDate FromDigits FromDMS Front FrontEndDynamicExpression FrontEndEventActions FrontEndExecute FrontEndObject FrontEndResource FrontEndResourceString FrontEndStackSize FrontEndToken FrontEndTokenExecute FrontEndValueCache FrontEndVersion FrontFaceColor FrontFaceOpacity Full FullAxes FullDefinition FullForm FullGraphics FullOptions FullSimplify Function FunctionExpand FunctionInterpolation FunctionSpace FussellVeselyImportance
syntax keyword mmaSystemSymbol GaborFilter GaborMatrix GaborWavelet GainMargins GainPhaseMargins Gamma GammaDistribution GammaRegularized GapPenalty Gather GatherBy GaugeFaceElementFunction GaugeFaceStyle GaugeFrameElementFunction GaugeFrameSize GaugeFrameStyle GaugeLabels GaugeMarkers GaugeStyle GaussianFilter GaussianIntegers GaussianMatrix GaussianWindow GCD GegenbauerC General GeneralizedLinearModelFit GenerateConditions GeneratedCell GeneratedParameters GeneratingFunction Generic GenericCylindricalDecomposition GenomeData GenomeLookup GeodesicClosing GeodesicDilation GeodesicErosion GeodesicOpening GeoDestination GeodesyData GeoDirection GeoDistance GeoGridPosition GeometricBrownianMotionProcess GeometricDistribution GeometricMean GeometricMeanFilter GeometricTransformation GeometricTransformation3DBox GeometricTransformation3DBoxOptions GeometricTransformationBox GeometricTransformationBoxOptions GeoPosition GeoPositionENU GeoPositionXYZ GeoProjectionData GestureHandler GestureHandlerTag Get GetBoundingBoxSizePacket GetContext GetEnvironment GetFileName GetFrontEndOptionsDataPacket GetLinebreakInformationPacket GetMenusPacket GetPageBreakInformationPacket Glaisher GlobalClusteringCoefficient GlobalPreferences GlobalSession Glow GoldenRatio GompertzMakehamDistribution GoodmanKruskalGamma GoodmanKruskalGammaTest Goto Grad Gradient GradientFilter GradientOrientationFilter Graph GraphAssortativity GraphCenter GraphComplement GraphData GraphDensity GraphDiameter GraphDifference GraphDisjointUnion
syntax keyword mmaSystemSymbol GraphDistance GraphDistanceMatrix GraphElementData GraphEmbedding GraphHighlight GraphHighlightStyle GraphHub Graphics Graphics3D Graphics3DBox Graphics3DBoxOptions GraphicsArray GraphicsBaseline GraphicsBox GraphicsBoxOptions GraphicsColor GraphicsColumn GraphicsComplex GraphicsComplex3DBox GraphicsComplex3DBoxOptions GraphicsComplexBox GraphicsComplexBoxOptions GraphicsContents GraphicsData GraphicsGrid GraphicsGridBox GraphicsGroup GraphicsGroup3DBox GraphicsGroup3DBoxOptions GraphicsGroupBox GraphicsGroupBoxOptions GraphicsGrouping GraphicsHighlightColor GraphicsRow GraphicsSpacing GraphicsStyle GraphIntersection GraphLayout GraphLinkEfficiency GraphPeriphery GraphPlot GraphPlot3D GraphPower GraphPropertyDistribution GraphQ GraphRadius GraphReciprocity GraphRoot GraphStyle GraphUnion Gray GrayLevel GreatCircleDistance Greater GreaterEqual GreaterEqualLess GreaterFullEqual GreaterGreater GreaterLess GreaterSlantEqual GreaterTilde Green Grid GridBaseline GridBox GridBoxAlignment GridBoxBackground GridBoxDividers GridBoxFrame GridBoxItemSize GridBoxItemStyle GridBoxOptions GridBoxSpacings GridCreationSettings GridDefaultElement GridElementStyleOptions GridFrame GridFrameMargins GridGraph GridLines GridLinesStyle GroebnerBasis GroupActionBase GroupCentralizer GroupElementFromWord GroupElementPosition GroupElementQ GroupElements GroupElementToWord GroupGenerators GroupMultiplicationTable GroupOrbits GroupOrder GroupPageBreakWithin GroupSetwiseStabilizer GroupStabilizer GroupStabilizerChain Gudermannian GumbelDistribution
syntax keyword mmaSystemSymbol HaarWavelet HadamardMatrix HalfNormalDistribution HamiltonianGraphQ HammingDistance HammingWindow HankelH1 HankelH2 HankelMatrix HannPoissonWindow HannWindow HaradaNortonGroupHN HararyGraph HarmonicMean HarmonicMeanFilter HarmonicNumber Hash HashTable Haversine HazardFunction Head HeadCompose Heads HeavisideLambda HeavisidePi HeavisideTheta HeldGroupHe HeldPart HelpBrowserLookup HelpBrowserNotebook HelpBrowserSettings HermiteDecomposition HermiteH HermitianMatrixQ HessenbergDecomposition Hessian HexadecimalCharacter Hexahedron HexahedronBox HexahedronBoxOptions HiddenSurface HighlightGraph HighlightImage HighpassFilter HigmanSimsGroupHS HilbertFilter HilbertMatrix Histogram Histogram3D HistogramDistribution HistogramList HistogramTransform HistogramTransformInterpolation HitMissTransform HITSCentrality HodgeDual HoeffdingD HoeffdingDTest Hold HoldAll HoldAllComplete HoldComplete HoldFirst HoldForm HoldPattern HoldRest HolidayCalendar HomeDirectory HomePage Horizontal HorizontalForm HorizontalGauge HorizontalScrollPosition HornerForm HotellingTSquareDistribution HoytDistribution HTMLSave Hue HumpDownHump HumpEqual HurwitzLerchPhi HurwitzZeta HyperbolicDistribution HypercubeGraph HyperexponentialDistribution Hyperfactorial Hypergeometric0F1 Hypergeometric0F1Regularized Hypergeometric1F1 Hypergeometric1F1Regularized Hypergeometric2F1 Hypergeometric2F1Regularized HypergeometricDistribution HypergeometricPFQ HypergeometricPFQRegularized HypergeometricU Hyperlink HyperlinkCreationSettings Hyphenation HyphenationOptions HypoexponentialDistribution HypothesisTestData
syntax keyword mmaSystemSymbol I Identity IdentityMatrix If IgnoreCase Im Image Image3D Image3DSlices ImageAccumulate ImageAdd ImageAdjust ImageAlign ImageApply ImageAspectRatio ImageAssemble ImageCache ImageCacheValid ImageCapture ImageChannels ImageClip ImageColorSpace ImageCompose ImageConvolve ImageCooccurrence ImageCorners ImageCorrelate ImageCorrespondingPoints ImageCrop ImageData ImageDataPacket ImageDeconvolve ImageDemosaic ImageDifference ImageDimensions ImageDistance ImageEffect ImageFeatureTrack ImageFileApply ImageFileFilter ImageFileScan ImageFilter ImageForestingComponents ImageForwardTransformation ImageHistogram ImageKeypoints ImageLevels ImageLines ImageMargins ImageMarkers ImageMeasurements ImageMultiply ImageOffset ImagePad ImagePadding ImagePartition ImagePeriodogram ImagePerspectiveTransformation ImageQ ImageRangeCache ImageReflect ImageRegion ImageResize ImageResolution ImageRotate ImageRotated ImageScaled ImageScan ImageSize ImageSizeAction ImageSizeCache ImageSizeMultipliers ImageSizeRaw ImageSubtract ImageTake ImageTransformation ImageTrim ImageType ImageValue ImageValuePositions Implies Import ImportAutoReplacements ImportString ImprovementImportance In IncidenceGraph IncidenceList IncidenceMatrix IncludeConstantBasis IncludeFileExtension IncludePods IncludeSingularTerm Increment Indent IndentingNewlineSpacings IndentMaxFraction IndependenceTest IndependentEdgeSetQ IndependentUnit IndependentVertexSetQ Indeterminate IndexCreationOptions Indexed IndexGraph IndexTag Inequality InexactNumberQ InexactNumbers Infinity Infix Information Inherited InheritScope Initialization InitializationCell InitializationCellEvaluation InitializationCellWarning InlineCounterAssignments InlineCounterIncrements InlineRules Inner Inpaint Input InputAliases InputAssumptions InputAutoReplacements InputField InputFieldBox InputFieldBoxOptions InputForm InputGrouping InputNamePacket InputNotebook InputPacket InputSettings InputStream InputString InputStringPacket InputToBoxFormPacket Insert InsertionPointObject InsertResults Inset Inset3DBox Inset3DBoxOptions InsetBox InsetBoxOptions Install InstallService InString Integer IntegerDigits IntegerExponent IntegerLength IntegerPart IntegerPartitions IntegerQ Integers IntegerString Integral Integrate Interactive InteractiveTradingChart Interlaced Interleaving InternallyBalancedDecomposition InterpolatingFunction InterpolatingPolynomial Interpolation InterpolationOrder InterpolationPoints InterpolationPrecision Interpretation InterpretationBox InterpretationBoxOptions InterpretationFunction
syntax keyword mmaSystemSymbol InterpretTemplate InterquartileRange Interrupt InterruptSettings Intersection Interval IntervalIntersection IntervalMemberQ IntervalUnion Inverse InverseBetaRegularized InverseCDF InverseChiSquareDistribution InverseContinuousWaveletTransform InverseDistanceTransform InverseEllipticNomeQ InverseErf InverseErfc InverseFourier InverseFourierCosTransform InverseFourierSequenceTransform InverseFourierSinTransform InverseFourierTransform InverseFunction InverseFunctions InverseGammaDistribution InverseGammaRegularized InverseGaussianDistribution InverseGudermannian InverseHaversine InverseJacobiCD InverseJacobiCN InverseJacobiCS InverseJacobiDC InverseJacobiDN InverseJacobiDS InverseJacobiNC InverseJacobiND InverseJacobiNS InverseJacobiSC InverseJacobiSD InverseJacobiSN InverseLaplaceTransform InversePermutation InverseRadon InverseSeries InverseSurvivalFunction InverseWaveletTransform InverseWeierstrassP InverseZTransform Invisible InvisibleApplication InvisibleTimes IrreduciblePolynomialQ IsolatingInterval IsomorphicGraphQ IsotopeData Italic Item ItemBox ItemBoxOptions ItemSize ItemStyle ItoProcess
syntax keyword mmaSystemSymbol JaccardDissimilarity JacobiAmplitude Jacobian JacobiCD JacobiCN JacobiCS JacobiDC JacobiDN JacobiDS JacobiNC JacobiND JacobiNS JacobiP JacobiSC JacobiSD JacobiSN JacobiSymbol JacobiZeta JankoGroupJ1 JankoGroupJ2 JankoGroupJ3 JankoGroupJ4 JarqueBeraALMTest JohnsonDistribution Join Joined JoinedCurve JoinedCurveBox JoinForm JordanDecomposition JordanModelDecomposition
syntax keyword mmaSystemSymbol K KagiChart KaiserBesselWindow KaiserWindow KalmanEstimator KalmanFilter KarhunenLoeveDecomposition KaryTree KatzCentrality KCoreComponents KDistribution KelvinBei KelvinBer KelvinKei KelvinKer KendallTau KendallTauTest KernelExecute KernelMixtureDistribution KernelObject Kernels Ket Khinchin KirchhoffGraph KirchhoffMatrix KleinInvariantJ KnightTourGraph KnotData KnownUnitQ KolmogorovSmirnovTest KroneckerDelta KroneckerModelDecomposition KroneckerProduct KroneckerSymbol KuiperTest KumaraswamyDistribution Kurtosis KuwaharaFilter
syntax keyword mmaSystemSymbol Label Labeled LabeledSlider LabelingFunction LabelStyle LaguerreL LambdaComponents LambertW LanczosWindow LandauDistribution Language LanguageCategory LaplaceDistribution LaplaceTransform Laplacian LaplacianFilter LaplacianGaussianFilter Large Larger Last Latitude LatitudeLongitude LatticeData LatticeReduce Launch LaunchKernels LayeredGraphPlot LayerSizeFunction LayoutInformation LCM LeafCount LeapYearQ LeastSquares LeastSquaresFilterKernel Left LeftArrow LeftArrowBar LeftArrowRightArrow LeftDownTeeVector LeftDownVector LeftDownVectorBar LeftRightArrow LeftRightVector LeftTee LeftTeeArrow LeftTeeVector LeftTriangle LeftTriangleBar LeftTriangleEqual LeftUpDownVector LeftUpTeeVector LeftUpVector LeftUpVectorBar LeftVector LeftVectorBar LegendAppearance Legended LegendFunction LegendLabel LegendLayout LegendMargins LegendMarkers LegendMarkerSize LegendreP LegendreQ LegendreType Length LengthWhile LerchPhi Less LessEqual LessEqualGreater LessFullEqual LessGreater LessLess LessSlantEqual LessTilde LetterCharacter LetterQ Level LeveneTest LeviCivitaTensor LevyDistribution Lexicographic LibraryFunction LibraryFunctionError LibraryFunctionInformation LibraryFunctionLoad LibraryFunctionUnload LibraryLoad LibraryUnload LicenseID LiftingFilterData LiftingWaveletTransform LightBlue LightBrown LightCyan Lighter LightGray LightGreen Lighting LightingAngle LightMagenta LightOrange LightPink LightPurple LightRed LightSources LightYellow Likelihood Limit LimitsPositioning LimitsPositioningTokens LindleyDistribution Line Line3DBox LinearFilter LinearFractionalTransform LinearModelFit LinearOffsetFunction LinearProgramming LinearRecurrence LinearSolve LinearSolveFunction LineBox LineBreak LinebreakAdjustments LineBreakChart LineBreakWithin LineColor LineForm LineGraph LineIndent LineIndentMaxFraction LineIntegralConvolutionPlot LineIntegralConvolutionScale LineLegend LineOpacity LineSpacing LineWrapParts LinkActivate LinkClose LinkConnect LinkConnectedQ LinkCreate LinkError LinkFlush LinkFunction LinkHost LinkInterrupt LinkLaunch LinkMode LinkObject LinkOpen LinkOptions LinkPatterns LinkProtocol LinkRead LinkReadHeld LinkReadyQ Links LinkWrite LinkWriteHeld LiouvilleLambda List Listable ListAnimate ListContourPlot ListContourPlot3D ListConvolve ListCorrelate ListCurvePathPlot ListDeconvolve ListDensityPlot Listen ListFourierSequenceTransform ListInterpolation ListLineIntegralConvolutionPlot ListLinePlot ListLogLinearPlot ListLogLogPlot ListLogPlot ListPicker ListPickerBox ListPickerBoxBackground ListPickerBoxOptions ListPlay ListPlot ListPlot3D ListPointPlot3D ListPolarPlot ListQ ListStreamDensityPlot ListStreamPlot ListSurfacePlot3D ListVectorDensityPlot ListVectorPlot ListVectorPlot3D ListZTransform Literal LiteralSearch LocalClusteringCoefficient LocalizeVariables LocationEquivalenceTest LocationTest Locator LocatorAutoCreate LocatorBox LocatorBoxOptions LocatorCentering LocatorPane LocatorPaneBox LocatorPaneBoxOptions
syntax keyword mmaSystemSymbol LocatorRegion Locked Log Log10 Log2 LogBarnesG LogGamma LogGammaDistribution LogicalExpand LogIntegral LogisticDistribution LogitModelFit LogLikelihood LogLinearPlot LogLogisticDistribution LogLogPlot LogMultinormalDistribution LogNormalDistribution LogPlot LogRankTest LogSeriesDistribution LongEqual Longest LongestAscendingSequence LongestCommonSequence LongestCommonSequencePositions LongestCommonSubsequence LongestCommonSubsequencePositions LongestMatch LongForm Longitude LongLeftArrow LongLeftRightArrow LongRightArrow Loopback LoopFreeGraphQ LowerCaseQ LowerLeftArrow LowerRightArrow LowerTriangularize LowpassFilter LQEstimatorGains LQGRegulator LQOutputRegulatorGains LQRegulatorGains LUBackSubstitution LucasL LuccioSamiComponents LUDecomposition LyapunovSolve LyonsGroupLy
syntax keyword mmaSystemSymbol MachineID MachineName MachineNumberQ MachinePrecision MacintoshSystemPageSetup Magenta Magnification Magnify MainSolve MaintainDynamicCaches Majority MakeBoxes MakeExpression MakeRules MangoldtLambda ManhattanDistance Manipulate Manipulator MannWhitneyTest MantissaExponent Manual Map MapAll MapAt MapIndexed MAProcess MapThread MarcumQ MardiaCombinedTest MardiaKurtosisTest MardiaSkewnessTest MarginalDistribution MarkovProcessProperties Masking MatchingDissimilarity MatchLocalNameQ MatchLocalNames MatchQ Material MathematicaNotation MathieuC MathieuCharacteristicA MathieuCharacteristicB MathieuCharacteristicExponent MathieuCPrime MathieuGroupM11 MathieuGroupM12 MathieuGroupM22 MathieuGroupM23 MathieuGroupM24 MathieuS MathieuSPrime MathMLForm MathMLText Matrices MatrixExp MatrixForm MatrixFunction MatrixLog MatrixPlot MatrixPower MatrixQ MatrixRank Max MaxBend MaxDetect MaxExtraBandwidths MaxExtraConditions MaxFeatures MaxFilter Maximize MaxIterations MaxMemoryUsed MaxMixtureKernels MaxPlotPoints MaxPoints MaxRecursion MaxStableDistribution MaxStepFraction MaxSteps MaxStepSize MaxValue MaxwellDistribution McLaughlinGroupMcL Mean MeanClusteringCoefficient MeanDegreeConnectivity MeanDeviation MeanFilter MeanGraphDistance MeanNeighborDegree MeanShift MeanShiftFilter Median MedianDeviation MedianFilter Medium MeijerG MeixnerDistribution MemberQ MemoryConstrained MemoryInUse Menu MenuAppearance MenuCommandKey MenuEvaluator MenuItem MenuPacket MenuSortingValue MenuStyle MenuView MergeDifferences Mesh MeshFunctions MeshRange MeshShading MeshStyle Message MessageDialog MessageList MessageName MessageOptions MessagePacket Messages MessagesNotebook MetaCharacters MetaInformation Method MethodOptions MexicanHatWavelet MeyerWavelet Min MinDetect MinFilter MinimalPolynomial MinimalStateSpaceModel Minimize Minors MinRecursion MinSize MinStableDistribution Minus MinusPlus MinValue Missing MissingDataMethod MittagLefflerE MixedRadix MixedRadixQuantity MixtureDistribution Mod Modal Mode Modular ModularLambda Module Modulus MoebiusMu Moment Momentary MomentConvert MomentEvaluate MomentGeneratingFunction Monday Monitor MonomialList MonomialOrder MonsterGroupM MorletWavelet MorphologicalBinarize MorphologicalBranchPoints MorphologicalComponents MorphologicalEulerNumber MorphologicalGraph MorphologicalPerimeter MorphologicalTransform Most MouseAnnotation MouseAppearance MouseAppearanceTag MouseButtons Mouseover MousePointerNote MousePosition MovingAverage MovingMedian MoyalDistribution MultiedgeStyle MultilaunchWarning MultiLetterItalics MultiLetterStyle MultilineFunction Multinomial MultinomialDistribution MultinormalDistribution MultiplicativeOrder Multiplicity Multiselection MultivariateHypergeometricDistribution MultivariatePoissonDistribution MultivariateTDistribution
syntax keyword mmaSystemSymbol N NakagamiDistribution NameQ Names NamespaceBox Nand NArgMax NArgMin NBernoulliB NCache NDSolve NDSolveValue Nearest NearestFunction NeedCurrentFrontEndPackagePacket NeedCurrentFrontEndSymbolsPacket NeedlemanWunschSimilarity Needs Negative NegativeBinomialDistribution NegativeMultinomialDistribution NeighborhoodGraph Nest NestedGreaterGreater NestedLessLess NestedScriptRules NestList NestWhile NestWhileList NevilleThetaC NevilleThetaD NevilleThetaN NevilleThetaS NewPrimitiveStyle NExpectation Next NextPrime NHoldAll NHoldFirst NHoldRest NicholsGridLines NicholsPlot NIntegrate NMaximize NMaxValue NMinimize NMinValue NominalVariables NonAssociative NoncentralBetaDistribution NoncentralChiSquareDistribution NoncentralFRatioDistribution NoncentralStudentTDistribution NonCommutativeMultiply NonConstants None NonlinearModelFit NonlocalMeansFilter NonNegative NonPositive Nor NorlundB Norm Normal NormalDistribution NormalGrouping Normalize NormalizedSquaredEuclideanDistance NormalsFunction NormFunction Not NotCongruent NotCupCap NotDoubleVerticalBar Notebook NotebookApply NotebookAutoSave NotebookClose NotebookConvertSettings NotebookCreate NotebookCreateReturnObject NotebookDefault NotebookDelete NotebookDirectory NotebookDynamicExpression NotebookEvaluate NotebookEventActions NotebookFileName NotebookFind NotebookFindReturnObject NotebookGet NotebookGetLayoutInformationPacket NotebookGetMisspellingsPacket NotebookInformation NotebookInterfaceObject NotebookLocate NotebookObject NotebookOpen NotebookOpenReturnObject NotebookPath NotebookPrint NotebookPut NotebookPutReturnObject NotebookRead NotebookResetGeneratedCells Notebooks NotebookSave NotebookSaveAs NotebookSelection NotebookSetupLayoutInformationPacket NotebooksMenu NotebookWrite NotElement NotEqualTilde NotExists NotGreater NotGreaterEqual NotGreaterFullEqual NotGreaterGreater NotGreaterLess NotGreaterSlantEqual NotGreaterTilde NotHumpDownHump NotHumpEqual NotLeftTriangle NotLeftTriangleBar NotLeftTriangleEqual NotLess NotLessEqual NotLessFullEqual NotLessGreater NotLessLess NotLessSlantEqual NotLessTilde NotNestedGreaterGreater NotNestedLessLess NotPrecedes NotPrecedesEqual NotPrecedesSlantEqual NotPrecedesTilde NotReverseElement NotRightTriangle NotRightTriangleBar NotRightTriangleEqual NotSquareSubset NotSquareSubsetEqual NotSquareSuperset NotSquareSupersetEqual NotSubset NotSubsetEqual NotSucceeds NotSucceedsEqual NotSucceedsSlantEqual NotSucceedsTilde NotSuperset NotSupersetEqual NotTilde NotTildeEqual NotTildeFullEqual NotTildeTilde NotVerticalBar NProbability NProduct NProductFactors NRoots NSolve NSum NSumTerms Null NullRecords NullSpace NullWords Number NumberFieldClassNumber NumberFieldDiscriminant NumberFieldFundamentalUnits NumberFieldIntegralBasis NumberFieldNormRepresentatives NumberFieldRegulator NumberFieldRootsOfUnity NumberFieldSignature NumberForm NumberFormat NumberMarks NumberMultiplier NumberPadding NumberPoint NumberQ NumberSeparator
syntax keyword mmaSystemSymbol NumberSigns NumberString Numerator NumericFunction NumericQ NuttallWindow NValues NyquistGridLines NyquistPlot
syntax keyword mmaSystemSymbol O ObservabilityGramian ObservabilityMatrix ObservableDecomposition ObservableModelQ OddQ Off Offset OLEData On ONanGroupON OneIdentity Opacity Open OpenAppend Opener OpenerBox OpenerBoxOptions OpenerView OpenFunctionInspectorPacket Opening OpenRead OpenSpecialOptions OpenTemporary OpenWrite Operate OperatingSystem OptimumFlowData Optional OptionInspectorSettings OptionQ Options OptionsPacket OptionsPattern OptionValue OptionValueBox OptionValueBoxOptions Or Orange Order OrderDistribution OrderedQ Ordering Orderless OrnsteinUhlenbeckProcess Orthogonalize Out Outer OutputAutoOverwrite OutputControllabilityMatrix OutputControllableModelQ OutputForm OutputFormData OutputGrouping OutputMathEditExpression OutputNamePacket OutputResponse OutputSizeLimit OutputStream Over OverBar OverDot Overflow OverHat Overlaps Overlay OverlayBox OverlayBoxOptions Overscript OverscriptBox OverscriptBoxOptions OverTilde OverVector OwenT OwnValues
syntax keyword mmaSystemSymbol PackingMethod PaddedForm Padding PadeApproximant PadLeft PadRight PageBreakAbove PageBreakBelow PageBreakWithin PageFooterLines PageFooters PageHeaderLines PageHeaders PageHeight PageRankCentrality PageWidth PairedBarChart PairedHistogram PairedSmoothHistogram PairedTTest PairedZTest PaletteNotebook PalettePath Pane PaneBox PaneBoxOptions Panel PanelBox PanelBoxOptions Paneled PaneSelector PaneSelectorBox PaneSelectorBoxOptions PaperWidth ParabolicCylinderD ParagraphIndent ParagraphSpacing ParallelArray ParallelCombine ParallelDo ParallelEvaluate Parallelization Parallelize ParallelMap ParallelNeeds ParallelProduct ParallelSubmit ParallelSum ParallelTable ParallelTry Parameter ParameterEstimator ParameterMixtureDistribution ParameterVariables ParametricFunction ParametricNDSolve ParametricNDSolveValue ParametricPlot ParametricPlot3D ParentConnect ParentDirectory ParentForm Parenthesize ParentList ParetoDistribution Part PartialCorrelationFunction PartialD ParticleData Partition PartitionsP PartitionsQ ParzenWindow PascalDistribution PassEventsDown PassEventsUp Paste PasteBoxFormInlineCells PasteButton Path PathGraph PathGraphQ Pattern PatternSequence PatternTest PauliMatrix PaulWavelet Pause PausedTime PDF PearsonChiSquareTest PearsonCorrelationTest PearsonDistribution PerformanceGoal PeriodicInterpolation Periodogram PeriodogramArray PermutationCycles PermutationCyclesQ PermutationGroup PermutationLength PermutationList PermutationListQ PermutationMax PermutationMin PermutationOrder PermutationPower PermutationProduct PermutationReplace Permutations PermutationSupport Permute PeronaMalikFilter Perpendicular PERTDistribution PetersenGraph PhaseMargins Pi Pick PIDData PIDDerivativeFilter PIDFeedforward PIDTune Piecewise PiecewiseExpand PieChart PieChart3D PillaiTrace PillaiTraceTest Pink Pivoting PixelConstrained PixelValue PixelValuePositions Placed Placeholder PlaceholderReplace Plain PlanarGraphQ Play PlayRange Plot Plot3D Plot3Matrix PlotDivision PlotJoined PlotLabel PlotLayout PlotLegends PlotMarkers PlotPoints PlotRange PlotRangeClipping PlotRangePadding PlotRegion PlotStyle Plus PlusMinus Pochhammer PodStates PodWidth Point Point3DBox PointBox PointFigureChart PointForm PointLegend PointSize PoissonConsulDistribution PoissonDistribution PoissonProcess PoissonWindow PolarAxes PolarAxesOrigin PolarGridLines PolarPlot PolarTicks PoleZeroMarkers PolyaAeppliDistribution PolyGamma Polygon Polygon3DBox Polygon3DBoxOptions PolygonBox PolygonBoxOptions PolygonHoleScale PolygonIntersections PolygonScale PolyhedronData PolyLog PolynomialExtendedGCD PolynomialForm PolynomialGCD PolynomialLCM PolynomialMod PolynomialQ PolynomialQuotient PolynomialQuotientRemainder PolynomialReduce PolynomialRemainder Polynomials PopupMenu PopupMenuBox PopupMenuBoxOptions PopupView PopupWindow Position Positive PositiveDefiniteMatrixQ PossibleZeroQ Postfix PostScript Power PowerDistribution PowerExpand PowerMod PowerModList
syntax keyword mmaSystemSymbol PowerSpectralDensity PowersRepresentations PowerSymmetricPolynomial Precedence PrecedenceForm Precedes PrecedesEqual PrecedesSlantEqual PrecedesTilde Precision PrecisionGoal PreDecrement PredictionRoot PreemptProtect PreferencesPath Prefix PreIncrement Prepend PrependTo PreserveImageOptions Previous PriceGraphDistribution PrimaryPlaceholder Prime PrimeNu PrimeOmega PrimePi PrimePowerQ PrimeQ Primes PrimeZetaP PrimitiveRoot PrincipalComponents PrincipalValue Print PrintAction PrintForm PrintingCopies PrintingOptions PrintingPageRange PrintingStartingPageNumber PrintingStyleEnvironment PrintPrecision PrintTemporary Prism PrismBox PrismBoxOptions PrivateCellOptions PrivateEvaluationOptions PrivateFontOptions PrivateFrontEndOptions PrivateNotebookOptions PrivatePaths Probability ProbabilityDistribution ProbabilityPlot ProbabilityPr ProbabilityScalePlot ProbitModelFit ProcessEstimator ProcessParameterAssumptions ProcessParameterQ ProcessStateDomain ProcessTimeDomain Product ProductDistribution ProductLog ProgressIndicator ProgressIndicatorBox ProgressIndicatorBoxOptions Projection Prolog PromptForm Properties Property PropertyList PropertyValue Proportion Proportional Protect Protected ProteinData Pruning PseudoInverse Purple Put PutAppend Pyramid PyramidBox PyramidBoxOptions
syntax keyword mmaSystemSymbol QBinomial QFactorial QGamma QHypergeometricPFQ QPochhammer QPolyGamma QRDecomposition QuadraticIrrationalQ Quantile QuantilePlot Quantity QuantityForm QuantityMagnitude QuantityQ QuantityUnit Quartics QuartileDeviation Quartiles QuartileSkewness QueueingNetworkProcess QueueingProcess QueueProperties Quiet Quit Quotient QuotientRemainder
syntax keyword mmaSystemSymbol RadialityCentrality RadicalBox RadicalBoxOptions RadioButton RadioButtonBar RadioButtonBox RadioButtonBoxOptions Radon RamanujanTau RamanujanTauL RamanujanTauTheta RamanujanTauZ Random RandomChoice RandomComplex RandomFunction RandomGraph RandomImage RandomInteger RandomPermutation RandomPrime RandomReal RandomSample RandomSeed RandomVariate RandomWalkProcess Range RangeFilter RangeSpecification RankedMax RankedMin Raster Raster3D Raster3DBox Raster3DBoxOptions RasterArray RasterBox RasterBoxOptions Rasterize RasterSize Rational RationalFunctions Rationalize Rationals Ratios Raw RawArray RawBoxes RawData RawMedium RayleighDistribution Re Read ReadList ReadProtected Real RealBlockDiagonalForm RealDigits RealExponent Reals Reap Record RecordLists RecordSeparators Rectangle RectangleBox RectangleBoxOptions RectangleChart RectangleChart3D RecurrenceFilter RecurrenceTable RecurringDigitsForm Red Reduce RefBox ReferenceLineStyle ReferenceMarkers ReferenceMarkerStyle Refine ReflectionMatrix ReflectionTransform Refresh RefreshRate RegionBinarize RegionFunction RegionPlot RegionPlot3D RegularExpression Regularization Reinstall Release ReleaseHold ReliabilityDistribution ReliefImage ReliefPlot Remove RemoveAlphaChannel RemoveAsynchronousTask Removed RemoveInputStreamMethod RemoveOutputStreamMethod RemoveProperty RemoveScheduledTask RenameDirectory RenameFile RenderAll RenderingOptions RenewalProcess RenkoChart Repeated RepeatedNull RepeatedString Replace ReplaceAll ReplaceHeldPart ReplaceImageValue ReplaceList ReplacePart ReplacePixelValue ReplaceRepeated Resampling Rescale RescalingTransform ResetDirectory ResetMenusPacket ResetScheduledTask Residue Resolve Rest Resultant ResumePacket Return ReturnExpressionPacket ReturnInputFormPacket ReturnPacket ReturnTextPacket Reverse ReverseBiorthogonalSplineWavelet ReverseElement ReverseEquilibrium ReverseGraph ReverseUpEquilibrium RevolutionAxis RevolutionPlot3D RGBColor RiccatiSolve RiceDistribution RidgeFilter RiemannR RiemannSiegelTheta RiemannSiegelZ Riffle Right RightArrow RightArrowBar RightArrowLeftArrow RightCosetRepresentative RightDownTeeVector RightDownVector RightDownVectorBar RightTee RightTeeArrow RightTeeVector RightTriangle RightTriangleBar RightTriangleEqual RightUpDownVector RightUpTeeVector RightUpVector RightUpVectorBar RightVector RightVectorBar RiskAchievementImportance RiskReductionImportance RogersTanimotoDissimilarity Root RootApproximant RootIntervals RootLocusPlot RootMeanSquare RootOfUnityQ RootReduce Roots RootSum Rotate RotateLabel RotateLeft RotateRight RotationAction RotationBox RotationBoxOptions RotationMatrix RotationTransform Round RoundImplies RoundingRadius Row RowAlignments RowBackgrounds RowBox RowHeights RowLines RowMinHeight RowReduce RowsEqual RowSpacings RSolve RudvalisGroupRu Rule RuleCondition RuleDelayed RuleForm RulerUnits Run RunScheduledTask RunThrough RuntimeAttributes RuntimeOptions RussellRaoDissimilarity
syntax keyword mmaSystemSymbol SameQ SameTest SampleDepth SampledSoundFunction SampledSoundList SampleRate SamplingPeriod SARIMAProcess SARMAProcess SatisfiabilityCount SatisfiabilityInstances SatisfiableQ Saturday Save Saveable SaveAutoDelete SaveDefinitions SawtoothWave Scale Scaled ScaleDivisions ScaledMousePosition ScaleOrigin ScalePadding ScaleRanges ScaleRangeStyle ScalingFunctions ScalingMatrix ScalingTransform Scan ScheduledTaskActiveQ ScheduledTaskData ScheduledTaskObject ScheduledTasks SchurDecomposition ScientificForm ScreenRectangle ScreenStyleEnvironment ScriptBaselineShifts ScriptLevel ScriptMinSize ScriptRules ScriptSizeMultipliers Scrollbars ScrollingOptions ScrollPosition Sec Sech SechDistribution SectionGrouping SectorChart SectorChart3D SectorOrigin SectorSpacing SeedRandom Select Selectable SelectComponents SelectedCells SelectedNotebook Selection SelectionAnimate SelectionCell SelectionCellCreateCell SelectionCellDefaultStyle SelectionCellParentStyle SelectionCreateCell SelectionDebuggerTag SelectionDuplicateCell SelectionEvaluate SelectionEvaluateCreateCell SelectionMove SelectionPlaceholder SelectionSetStyle SelectWithContents SelfLoops SelfLoopStyle SemialgebraicComponentInstances SendMail Sequence SequenceAlignment SequenceForm SequenceHold SequenceLimit Series SeriesCoefficient SeriesData SessionTime Set SetAccuracy SetAlphaChannel SetAttributes Setbacks SetBoxFormNamesPacket SetDelayed SetDirectory SetEnvironment SetEvaluationNotebook SetFileDate SetFileLoadingContext SetNotebookStatusLine SetOptions SetOptionsPacket SetPrecision SetProperty SetSelectedNotebook SetSharedFunction SetSharedVariable SetSpeechParametersPacket SetStreamPosition SetSystemOptions Setter SetterBar SetterBox SetterBoxOptions Setting SetValue Shading Shallow ShannonWavelet ShapiroWilkTest Share Sharpen ShearingMatrix ShearingTransform ShenCastanMatrix Short ShortDownArrow Shortest ShortestMatch ShortestPathFunction ShortLeftArrow ShortRightArrow ShortUpArrow Show ShowAutoStyles ShowCellBracket ShowCellLabel ShowCellTags ShowClosedCellArea ShowContents ShowControls ShowCursorTracker ShowGroupOpenCloseIcon ShowGroupOpener ShowInvisibleCharacters ShowPageBreaks ShowPredictiveInterface ShowSelection ShowShortBoxForm ShowSpecialCharacters ShowStringCharacters ShowSyntaxStyles ShrinkingDelay ShrinkWrapBoundingBox SiegelTheta SiegelTukeyTest Sign Signature SignedRankTest SignificanceLevel SignPadding SignTest SimilarityRules SimpleGraph SimpleGraphQ Simplify Sin Sinc SinghMaddalaDistribution SingleEvaluation SingleLetterItalics SingleLetterStyle SingularValueDecomposition SingularValueList SingularValuePlot SingularValues Sinh SinhIntegral SinIntegral SixJSymbol Skeleton SkeletonTransform SkellamDistribution Skewness SkewNormalDistribution Skip SliceDistribution Slider Slider2D Slider2DBox Slider2DBoxOptions SliderBox SliderBoxOptions SlideView Slot SlotSequence Small SmallCircle Smaller SmithDelayCompensator SmithWatermanSimilarity
syntax keyword mmaSystemSymbol SmoothDensityHistogram SmoothHistogram SmoothHistogram3D SmoothKernelDistribution SocialMediaData Socket SokalSneathDissimilarity Solve SolveAlways SolveDelayed Sort SortBy Sound SoundAndGraphics SoundNote SoundVolume Sow Space SpaceForm Spacer Spacings Span SpanAdjustments SpanCharacterRounding SpanFromAbove SpanFromBoth SpanFromLeft SpanLineThickness SpanMaxSize SpanMinSize SpanningCharacters SpanSymmetric SparseArray SpatialGraphDistribution Speak SpeakTextPacket SpearmanRankTest SpearmanRho Spectrogram SpectrogramArray Specularity SpellingCorrection SpellingDictionaries SpellingDictionariesPath SpellingOptions SpellingSuggestionsPacket Sphere SphereBox SphericalBesselJ SphericalBesselY SphericalHankelH1 SphericalHankelH2 SphericalHarmonicY SphericalPlot3D SphericalRegion SpheroidalEigenvalue SpheroidalJoiningFactor SpheroidalPS SpheroidalPSPrime SpheroidalQS SpheroidalQSPrime SpheroidalRadialFactor SpheroidalS1 SpheroidalS1Prime SpheroidalS2 SpheroidalS2Prime Splice SplicedDistribution SplineClosed SplineDegree SplineKnots SplineWeights Split SplitBy SpokenString Sqrt SqrtBox SqrtBoxOptions Square SquaredEuclideanDistance SquareFreeQ SquareIntersection SquaresR SquareSubset SquareSubsetEqual SquareSuperset SquareSupersetEqual SquareUnion SquareWave StabilityMargins StabilityMarginsStyle StableDistribution Stack StackBegin StackComplete StackInhibit StandardDeviation StandardDeviationFilter StandardForm Standardize StandbyDistribution Star StarGraph StartAsynchronousTask StartingStepSize StartOfLine StartOfString StartScheduledTask StartupSound StateDimensions StateFeedbackGains StateOutputEstimator StateResponse StateSpaceModel StateSpaceRealization StateSpaceTransform StationaryDistribution StationaryWaveletPacketTransform StationaryWaveletTransform StatusArea StatusCentrality StepMonitor StieltjesGamma StirlingS1 StirlingS2 StopAsynchronousTask StopScheduledTask StrataVariables StratonovichProcess StreamColorFunction StreamColorFunctionScaling StreamDensityPlot StreamPlot StreamPoints StreamPosition Streams StreamScale StreamStyle String StringBreak StringByteCount StringCases StringCount StringDrop StringExpression StringForm StringFormat StringFreeQ StringInsert StringJoin StringLength StringMatchQ StringPosition StringQ StringReplace StringReplaceList StringReplacePart StringReverse StringRotateLeft StringRotateRight StringSkeleton StringSplit StringTake StringToStream StringTrim StripBoxes StripOnInput StripWrapperBoxes StrokeForm StructuralImportance StructuredArray StructuredSelection StruveH StruveL Stub StudentTDistribution Style StyleBox StyleBoxAutoDelete StyleBoxOptions StyleData StyleDefinitions StyleForm StyleKeyMapping StyleMenuListing StyleNameDialogSettings StyleNames StylePrint StyleSheetPath Subfactorial Subgraph SubMinus SubPlus SubresultantPolynomialRemainders
syntax keyword mmaSystemSymbol SubresultantPolynomials Subresultants Subscript SubscriptBox SubscriptBoxOptions Subscripted Subset SubsetEqual Subsets SubStar Subsuperscript SubsuperscriptBox SubsuperscriptBoxOptions Subtract SubtractFrom SubValues Succeeds SucceedsEqual SucceedsSlantEqual SucceedsTilde SuchThat Sum SumConvergence Sunday SuperDagger SuperMinus SuperPlus Superscript SuperscriptBox SuperscriptBoxOptions Superset SupersetEqual SuperStar Surd SurdForm SurfaceColor SurfaceGraphics SurvivalDistribution SurvivalFunction SurvivalModel SurvivalModelFit SuspendPacket SuzukiDistribution SuzukiGroupSuz SwatchLegend Switch Symbol SymbolName SymletWavelet Symmetric SymmetricGroup SymmetricMatrixQ SymmetricPolynomial SymmetricReduction Symmetrize SymmetrizedArray SymmetrizedArrayRules SymmetrizedDependentComponents SymmetrizedIndependentComponents SymmetrizedReplacePart SynchronousInitialization SynchronousUpdating Syntax SyntaxForm SyntaxInformation SyntaxLength SyntaxPacket SyntaxQ SystemDialogInput SystemException SystemHelpPath SystemInformation SystemInformationData SystemOpen SystemOptions SystemsModelDelay SystemsModelDelayApproximate SystemsModelDelete SystemsModelDimensions SystemsModelExtract SystemsModelFeedbackConnect SystemsModelLabels SystemsModelOrder SystemsModelParallelConnect SystemsModelSeriesConnect SystemsModelStateFeedbackConnect SystemStub
syntax keyword mmaSystemSymbol Tab TabFilling Table TableAlignments TableDepth TableDirections TableForm TableHeadings TableSpacing TableView TableViewBox TabSpacings TabView TabViewBox TabViewBoxOptions TagBox TagBoxNote TagBoxOptions TaggingRules TagSet TagSetDelayed TagStyle TagUnset Take TakeWhile Tally Tan Tanh TargetFunctions TargetUnits TautologyQ TelegraphProcess TemplateBox TemplateBoxOptions TemplateSlotSequence TemporalData Temporary TemporaryVariable TensorContract TensorDimensions TensorExpand TensorProduct TensorQ TensorRank TensorReduce TensorSymmetry TensorTranspose TensorWedge Tetrahedron TetrahedronBox TetrahedronBoxOptions TeXForm TeXSave Text Text3DBox Text3DBoxOptions TextAlignment TextBand TextBoundingBox TextBox TextCell TextClipboardType TextData TextForm TextJustification TextLine TextPacket TextParagraph TextRecognize TextRendering TextStyle Texture TextureCoordinateFunction TextureCoordinateScaling Therefore ThermometerGauge Thick Thickness Thin Thinning ThisLink ThompsonGroupTh Thread ThreeJSymbol Threshold Through Throw Thumbnail Thursday Ticks TicksStyle Tilde TildeEqual TildeFullEqual TildeTilde TimeConstrained TimeConstraint Times TimesBy TimeSeriesForecast TimeSeriesInvertibility TimeUsed TimeValue TimeZone Timing Tiny TitleGrouping TitsGroupT ToBoxes ToCharacterCode ToColor ToContinuousTimeModel ToDate ToDiscreteTimeModel ToeplitzMatrix ToExpression ToFileName Together Toggle ToggleFalse Toggler TogglerBar TogglerBox TogglerBoxOptions ToHeldExpression ToInvertibleTimeSeries TokenWords Tolerance ToLowerCase ToNumberField TooBig Tooltip TooltipBox TooltipBoxOptions TooltipDelay TooltipStyle Top TopHatTransform TopologicalSort ToRadicals ToRules ToString Total TotalHeight TotalVariationFilter TotalWidth TouchscreenAutoZoom TouchscreenControlPlacement ToUpperCase Tr Trace TraceAbove TraceAction TraceBackward TraceDepth TraceDialog TraceForward TraceInternal TraceLevel TraceOff TraceOn TraceOriginal TracePrint TraceScan TrackedSymbols TradingChart TraditionalForm TraditionalFunctionNotation TraditionalNotation TraditionalOrder TransferFunctionCancel TransferFunctionExpand TransferFunctionFactor TransferFunctionModel TransferFunctionPoles TransferFunctionTransform TransferFunctionZeros TransformationFunction TransformationFunctions TransformationMatrix TransformedDistribution TransformedField Translate TranslationTransform TransparentColor Transpose TreeForm TreeGraph TreeGraphQ TreePlot TrendStyle TriangleWave TriangularDistribution Trig TrigExpand TrigFactor TrigFactorList Trigger TrigReduce TrigToExp TrimmedMean True TrueQ TruncatedDistribution TsallisQExponentialDistribution TsallisQGaussianDistribution TTest Tube TubeBezierCurveBox TubeBezierCurveBoxOptions TubeBox TubeBSplineCurveBox TubeBSplineCurveBoxOptions Tuesday TukeyLambdaDistribution TukeyWindow Tuples TuranGraph TuringMachine
syntax keyword mmaSystemSymbol Transparent "Vim keyword!
syntax keyword mmaSystemSymbol UnateQ Uncompress Undefined UnderBar Underflow Underlined Underoverscript UnderoverscriptBox UnderoverscriptBoxOptions Underscript UnderscriptBox UnderscriptBoxOptions UndirectedEdge UndirectedGraph UndirectedGraphQ UndocumentedTestFEParserPacket UndocumentedTestGetSelectionPacket Unequal Unevaluated UniformDistribution UniformGraphDistribution UniformSumDistribution Uninstall Union UnionPlus Unique UnitBox UnitConvert UnitDimensions Unitize UnitRootTest UnitSimplify UnitStep UnitTriangle UnitVector Unprotect UnsameQ UnsavedVariables Unset UnsetShared UntrackedVariables Up UpArrow UpArrowBar UpArrowDownArrow Update UpdateDynamicObjects UpdateDynamicObjectsSynchronous UpdateInterval UpDownArrow UpEquilibrium UpperCaseQ UpperLeftArrow UpperRightArrow UpperTriangularize Upsample UpSet UpSetDelayed UpTee UpTeeArrow UpValues URL URLFetch URLFetchAsynchronous URLSave URLSaveAsynchronous UseGraphicsRange Using UsingFrontEnd
syntax keyword mmaSystemSymbol V2Get ValidationLength Value ValueBox ValueBoxOptions ValueForm ValueQ ValuesData Variables Variance VarianceEquivalenceTest VarianceEstimatorFunction VarianceGammaDistribution VarianceTest VectorAngle VectorColorFunction VectorColorFunctionScaling VectorDensityPlot VectorGlyphData VectorPlot VectorPlot3D VectorPoints VectorQ Vectors VectorScale VectorStyle Vee Verbatim Verbose VerboseConvertToPostScriptPacket VerifyConvergence VerifySolutions VerifyTestAssumptions Version VersionNumber VertexAdd VertexCapacity VertexColors VertexComponent VertexConnectivity VertexCoordinateRules VertexCoordinates VertexCorrelationSimilarity VertexCosineSimilarity VertexCount VertexCoverQ VertexDataCoordinates VertexDegree VertexDelete VertexDiceSimilarity VertexEccentricity VertexInComponent VertexInDegree VertexIndex VertexJaccardSimilarity VertexLabeling VertexLabels VertexLabelStyle VertexList VertexNormals VertexOutComponent VertexOutDegree VertexQ VertexRenderingFunction VertexReplace VertexShape VertexShapeFunction VertexSize VertexStyle VertexTextureCoordinates VertexWeight Vertical VerticalBar VerticalForm VerticalGauge VerticalSeparator VerticalSlider VerticalTilde ViewAngle ViewCenter ViewMatrix ViewPoint ViewPointSelectorSettings ViewPort ViewRange ViewVector ViewVertical VirtualGroupData Visible VisibleCell VoigtDistribution VonMisesDistribution
syntax keyword mmaSystemSymbol WaitAll WaitAsynchronousTask WaitNext WaitUntil WakebyDistribution WalleniusHypergeometricDistribution WaringYuleDistribution WatershedComponents WatsonUSquareTest WattsStrogatzGraphDistribution WaveletBestBasis WaveletFilterCoefficients WaveletImagePlot WaveletListPlot WaveletMapIndexed WaveletMatrixPlot WaveletPhi WaveletPsi WaveletScale WaveletScalogram WaveletThreshold WeaklyConnectedComponents WeaklyConnectedGraphQ WeakStationarity WeatherData WeberE Wedge Wednesday WeibullDistribution WeierstrassHalfPeriods WeierstrassInvariants WeierstrassP WeierstrassPPrime WeierstrassSigma WeierstrassZeta WeightedAdjacencyGraph WeightedAdjacencyMatrix WeightedData WeightedGraphQ Weights WelchWindow WheelGraph WhenEvent Which While White Whitespace WhitespaceCharacter WhittakerM WhittakerW WienerFilter WienerProcess WignerD WignerSemicircleDistribution WilksW WilksWTest WindowClickSelect WindowElements WindowFloating WindowFrame WindowFrameElements WindowMargins WindowMovable WindowOpacity WindowSelected WindowSize WindowStatusArea WindowTitle WindowToolbars WindowWidth With WolframAlpha WolframAlphaDate WolframAlphaQuantity WolframAlphaResult Word WordBoundary WordCharacter WordData WordSearch WordSeparators WorkingPrecision Write WriteString Wronskian
syntax keyword mmaSystemSymbol XMLElement XMLObject Xnor Xor
syntax keyword mmaSystemSymbol Yellow YuleDissimilarity
syntax keyword mmaSystemSymbol ZernikeR ZeroSymmetric ZeroTest ZeroWidthTimes Zeta ZetaZero ZipfDistribution ZTest ZTransform
syntax keyword mmaSystemSymbol $Aborted $ActivationGroupID $ActivationKey $ActivationUserRegistered $AddOnsDirectory $AssertFunction $Assumptions $AsynchronousTask $BaseDirectory $BatchInput $BatchOutput $BoxForms $ByteOrdering $Canceled $CharacterEncoding $CharacterEncodings $CommandLine $CompilationTarget $ConditionHold $ConfiguredKernels $Context $ContextPath $ControlActiveSetting $CreationDate $CurrentLink $DateStringFormat $DefaultFont $DefaultFrontEnd $DefaultImagingDevice $DefaultPath $Display $DisplayFunction $DistributedContexts $DynamicEvaluation $Echo $Epilog $ExportFormats $Failed $FinancialDataSource $FormatType $FrontEnd $FrontEndSession $GeoLocation $HistoryLength $HomeDirectory $HTTPCookies $IgnoreEOF $ImagingDevices $ImportFormats $InitialDirectory $Input $InputFileName $InputStreamMethods $Inspector $InstallationDate $InstallationDirectory $InterfaceEnvironment $IterationLimit $KernelCount $KernelID $Language $LaunchDirectory $LibraryPath $LicenseExpirationDate $LicenseID $LicenseProcesses $LicenseServer $LicenseSubprocesses $LicenseType $Line $Linked $LinkSupported $LoadedFiles $MachineAddresses $MachineDomain $MachineDomains $MachineEpsilon $MachineID $MachineName $MachinePrecision $MachineType $MaxExtraPrecision $MaxLicenseProcesses $MaxLicenseSubprocesses $MaxMachineNumber $MaxNumber $MaxPiecewiseCases $MaxPrecision $MaxRootDegree $MessageGroups $MessageList $MessagePrePrint $Messages $MinMachineNumber $MinNumber $MinorReleaseNumber $MinPrecision $ModuleNumber $NetworkLicense $NewMessage $NewSymbol $Notebooks $NumberMarks $Off $OperatingSystem $Output $OutputForms $OutputSizeLimit $OutputStreamMethods $Packages $ParentLink $ParentProcessID $PasswordFile $PatchLevelID $Path $PathnameSeparator $PerformanceGoal $PipeSupported $Post $Pre $PreferencesDirectory $PrePrint $PreRead $PrintForms $PrintLiteral $ProcessID $ProcessorCount $ProcessorType $ProductInformation $ProgramName $RandomState $RecursionLimit $ReleaseNumber $RootDirectory $ScheduledTask $ScriptCommandLine $SessionID $SetParentLink $SharedFunctions $SharedVariables $SoundDisplay $SoundDisplayFunction $SuppressInputFormHeads $SynchronousEvaluation $SyntaxHandler $System $SystemCharacterEncoding $SystemID $SystemWordLength $TemporaryDirectory $TemporaryPrefix $TextStyle $TimedOut $TimeUnit $TimeZone $TopDirectory $TraceOff $TraceOn $TracePattern $TracePostAction $TracePreAction $Urgent $UserAddOnsDirectory $UserBaseDirectory $UserDocumentsDirectory $UserName $Version $VersionNumber

"Symbols added in version 10.0.0
syntax keyword mmaSystemSymbol AASTriangle Activate AdministrativeDivisionData AffineStateSpaceModel AircraftData AirportData AirPressureData AirTemperatureData AllowedHeads AllowIncomplete AllowLooseGrammar AllowTransliteration AllTrue AlternateImage AlternatingFactorial AmbiguityFunction AmbiguityList AntihermitianMatrixQ AntisymmetricMatrixQ AnyOrder AnyTrue APIFunction APIFunctionGroup AppearanceRules ArcCurvature ARCHProcess ArcLength Area ArrayResample ASATriangle AssociateTo Association AssociationFormat AssociationMap AssociationQ AssociationThread AsymptoticOutputTracker AutocorrelationTest Ball BarcodeImage BarcodeRecognize BooleanQ BooleanRegion BooleanStrings BoundaryDiscretizeGraphics BoundaryDiscretizeRegion BoundaryMesh BoundaryMeshRegion BoundaryMeshRegionQ BoundedRegionQ BoxObject BridgeData BroadcastStationData BuildingData CalendarConvert CanonicalGraph CanonicalName CantorStaircase CarlemanLinearize CaseSensitive Catenate CelestialSystem ChromaticityPlot ChromaticityPlot3D ChromaticPolynomial Circumsphere ClassifierFunction ClassifierInformation ClassifierMeasurements Classify ClassPriors ClipPlanesStyle CloudAccountData CloudBase CloudConnect CloudDeploy CloudDirectory CloudDisconnect CloudEvaluate CloudExport CloudFunction CloudGet CloudImport CloudObject CloudObjectInformation CloudObjectInformationData CloudObjects CloudPut CloudSave CloudSymbol CodeAssistOptions ColorCoverage ColorDistance ColorQ ColumnSpans CombinerFunction CometData CommonName CompanyData CompositeQ ConformImages ConicHullRegion ConicHullRegion3DBox ConicHullRegionBox ConnectedMeshComponents ConnectLibraryCallbackFunction ConstantImage ConstantRegionQ ConstellationData ConvexHullMesh CountDistinct CountDistinctBy Counts CountsBy CreateDatabin CreateManagedLibraryExpression CreateNotebook CreateUUID CurrencyConvert DamData Databin DatabinAdd Databins DataForm Dataset DatedUnit DateFormat DateObject DateObjectQ DateValue DayHemisphere DaylightQ DayNightTerminator DeepSpaceProbeData DefaultParameterType DefaultReturnType DefaultValue DefaultView DelaunayMesh Delayed DeleteDuplicatesBy DeleteMissing DelimitedSequence DestroyAfterEvaluation DeviceClose DeviceConfigure DeviceExecute DeviceExecuteAsynchronous DeviceObject DeviceOpen DeviceOpenQ DeviceRead DeviceReadBuffer DeviceReadLatest DeviceReadList DeviceReadTimeSeries Devices DeviceStreams DeviceWrite DeviceWriteBuffer DiagonalizableMatrixQ DimensionalCombinations DimensionalMeshComponents DirichletBeta DirichletCondition DirichletEta DirichletLambda DiscretizeGraphics DiscretizeRegion DisjointQ DispatchQ DSolveValue

syntax keyword mmaSystemSymbol EarthImpactData EarthquakeData EclipseType EdgeContract EdgeCycleMatrix ElidedForms Ellipsoid EmbedCode EmbeddedHTML EmbeddingObject EmptyRegion EndOfBuffer EngineEnvironment Entity EntityClass EntityClassList EntityList EntityProperties EntityProperty EntityPropertyClass EntityTypeName EntityValue EstimatedBackground EvaluationBox EvaluationData EventSeries ExcludedLines ExcludedPhysicalQuantities ExecuteScheduledTask ExoplanetData ExportForm ExternalBundle ExternalFunctionName ExternalOptions ExternalTypeSignature Failure FailureAction FareySequence FeedbackLinearize Fibonorial FileTemplate FileTemplateApply FindCycle FindDevices FindEdgeIndependentPaths FindFundamentalCycles FindHiddenMarkovStates FindPath FindPeaks FindSpanningTree FindVertexIndependentPaths FirstCase FirstPosition FixedOrder FlowPolynomial FormatName FormFunction FormLayoutFunction FormObject FormTemplate FormTheme FormulaData FormulaLookup FractionalGaussianNoiseProcess FrenetSerretSystem FresnelF FresnelG FromEntity FullInformationOutputRegulator FullRegion FunctionDomain FunctionPeriod FunctionRange GalaxyData GARCHProcess GenerateDocument GeoBackground GeoBoundingBox GeoBounds GeoCenter GeoCircle GeoDisk GeoDisplacement GeoElevationData GeoEntities GeoGraphics GeoGridLines GeoGridLinesStyle GeoGroup GeoIdentify GeoLabels GeoListPlot GeoLocation GeologicalPeriodData GeoMarker GeoModel GeoNearest GeoPath GeoProjection GeoRange GeoRangePadding GeoRegionValuePlot GeoScaleBar GeoStyling GeoStylingImageFunction GeoVariant GeoVisibleRegion GeoVisibleRegionBoundary GeoWithinQ GeoZoomLevel Grammar GrammarToken Graph3D GraphAutomorphismGroup GroupBy GroupTogetherGrouping GroupTogetherNestedGrouping GrowCutComponents HalfLine HalfPlane HeaderLines Here HiddenMarkovProcess HighlightMesh HistoricalPeriodData HTTPRedirect HTTPRequestData HTTPResponse IconData IconRules IgnoringInactive ImageApplyIndexed ImageCollage ImageFormattingWidth ImageSaliencyFilter ImagingDevice ImplicitRegion Inactivate Inactive IncludeQuantities IncludeWindowTimes IndefiniteMatrixQ IndeterminateThreshold IndexBy InfiniteLine InfinitePlane InflationAdjust InflationMethod InlinePart InsertionFunction IntegerName Interpreter IntersectingQ IntervalSlider InverseTransformedRegion IslandData JoinAcross JuliaSetBoettcher JuliaSetIterationCount JuliaSetPlot JuliaSetPoints KEdgeConnectedComponents KEdgeConnectedGraphQ Key KeyComplement KeyDrop KeyDropFrom KeyExistsQ KeyFreeQ KeyIntersection KeyMap KeyMemberQ KeypointStrength KeyRenaming Keys KeySelect KeySort KeySortBy KeyTake KeyUnion KillProcess KVertexConnectedComponents KVertexConnectedGraphQ
syntax keyword mmaSystemSymbol LABColor LakeData LaminaData LanguageData LCHColor LibraryDataType LinearGradientImage LinearizingTransformationData LinebreakSemicolonWeighting LinkRankCentrality LinkService ListFormat LocalAdaptiveBinarize LocalizeDefinitions LocalTime LocalTimeZone LogisticSigmoid Lookup LunarEclipse LUVColor ManagedLibraryExpressionID ManagedLibraryExpressionQ MandelbrotSetBoettcher MandelbrotSetDistance MandelbrotSetIterationCount MandelbrotSetMemberQ MandelbrotSetPlot MannedSpaceMissionData MaxCellMeasure MaximalBy MedicalTestData MemoryConstraint Merge MeshCellCentroid MeshCellCount MeshCellIndex MeshCellLabel MeshCellMarker MeshCellMeasure MeshCellQuality MeshCells MeshCellStyle MeshCoordinates MeshPrimitives MeshQualityGoal MeshRefinementFunction MeshRegion MeshRegionQ MeteorShowerData MinColorDistance MineralData MinimalBy MinimumTimeIncrement MinIntervalSize MinkowskiQuestionMark MinorPlanetData MissingBehavior MissingDataRules MissingString MissingStyle MixedGraphQ MoonPhase MoonPosition MountainData MovieData MovingMap Multicolumn MultigraphQ NebulaData NegativeDefiniteMatrixQ NegativeSemidefiniteMatrixQ NeighborhoodData NeumannValue NextScheduledTaskTime NightHemisphere NoneTrue NonlinearStateSpaceModel Normalized NormalMatrixQ NotebookTemplate Now NuclearExplosionData NuclearReactorData NumberLinePlot OceanData OptionalElement OrthogonalMatrixQ OverwriteTarget Package Parallelepiped Parallelogram ParametricRegion ParentBox ParentCell ParentNotebook ParkData Parse PartBehavior ParticleAcceleratorData PeakDetect Permissions PersonData PhaseRange PhysicalSystemData Pivot PlanckRadiationLaw PlaneCurveData PlanetaryMoonData PlanetData PlantData PlotRangeClipPlanesStyle PlotTheme Pluralize PositionIndex PositiveSemidefiniteMatrixQ PowerRange Predict PredictorFunction PredictorInformation PredictorMeasurements PrimitiveRootList ProcessConnection ProcessDirectory ProcessEnvironment Processes ProcessInformation ProcessObject ProcessStatus PulsarData Qualifiers QuantityThread QuantityVariable QuantityVariableCanonicalUnit QuantityVariableDimensions QuantityVariableIdentifier QuantityVariablePhysicalQuantity Query RadialGradientImage RandomColor ReadLine ReadString RegionBoundary RegionBounds RegionCentroid RegionDifference RegionDimension RegionDistance RegionDistanceFunction RegionEmbeddingDimension RegionIntersection RegionMeasure RegionMember RegionMemberFunction RegionNearest RegionNearestFunction RegionProduct RegionQ RegionSymmetricDifference RegionUnion RegularlySampledQ RemoveBackground RequiredPhysicalQuantities ResamplingMethod ResponseForm Restricted RiemannXi RightComposition RSolveValue RunProcess

syntax keyword mmaSystemSymbol SASTriangle SatelliteData SavitzkyGolayMatrix ScheduledTask ScorerGi ScorerGiPrime ScorerHi ScorerHiPrime ScriptForm SelectFirst SemanticImport SemanticImportString SemanticInterpretation SendMessage ServiceConnect ServiceDisconnect ServiceExecute ServiceObject SetCloudDirectory SiderealTime SignedRegionDistance Simplex SolarEclipse SolarSystemFeatureData SolidData SourceEntityType SpaceCurveData SpeciesData SquareMatrixQ SSSTriangle StandardAtmosphereData StarClusterData StarData StartProcess StateTransformationLinearize StringTemplate String$ SubsetQ SunPosition Sunrise Sunset SupernovaData SurfaceData SystemGet SystemsModelLinearity SystemsModelMerge SystemsModelVectorRelativeOrders TemplateApply TemplateExpression TemplateIf TemplateObject TemplateSequence TemplateSlot TemplateWith TemporalRegularity TestID TestReport TestReportObject TestResultObject TextLegend TextString ThermodynamicData ThreadDepth TimeDirection TimeFormat TimeObject Timeout TimeSeries TimeSeriesAggregate TimeSeriesInsert TimeSeriesMap TimeSeriesMapThread TimeSeriesModel TimeSeriesModelFit TimeSeriesResample TimeSeriesRescale TimeSeriesShift TimeSeriesThread TimeSeriesWindow TimeZoneConvert Today ToEntity Tomorrow TouchPosition TrackingFunction TransformationClass TransformedProcess TransformedRegion TransitionDirection TransitionDuration TransitionEffect TransitiveClosureGraph TransitiveReductionGraph TrapSelection Triangle TriangulateMesh TropicalStormData TunnelData TuttePolynomial UnderseaFeatureData UndoOptions UndoTrackedVariables UnitaryMatrixQ UnitSystem UnityDimensions UniversityData URLBuild URLDecode URLEncode URLExecute URLExistsQ URLExpand URLParse URLQueryDecode URLQueryEncode URLShorten UserDefinedWavelet UtilityFunction ValidateQuery ValidationSet ValueDimensions Values VerificationTest VertexContract VolcanoData Volume VoronoiMesh WhiteNoiseProcess WhitePoint WindDirectionData WindSpeedData WindVectorData WrapAround WriteLine XMLTemplate XYZColor Yesterday ZIPCodeData $CloudBase $CloudConnected $CloudCreditsAvailable $CloudEvaluation $CloudRootDirectory $CloudSymbolBase $EmbedCodeEnvironments $EvaluationCloudObject $EvaluationEnvironment $GeoEntityTypes $GeoLocationCity $GeoLocationCountry $GeoLocationPrecision $GeoLocationSource $HTMLExportRules $ImageFormattingWidth $ImagingDevice $InterpreterTypes $Permissions $PlotTheme $RegisteredDeviceClasses $RegisteredUserName $RequesterAddress $RequesterWolframID $RequesterWolframUUID $Services $SystemShell $TemplatePath $UnitSystem $UserAgentLanguages $UserAgentMachine $UserAgentName $UserAgentOperatingSystem $UserAgentString $UserAgentVersion $WolframID $WolframUUID

"User Symbols
syntax match mmaSymbol "[^0-9][A-Za-z0-9`$]\+\s*\%([@[]\|/:\|/\=/@\)\@=" contains=mmaOperator,mmaSystemSymbol,mmaBrackets
syntax match mmaSymbol "\<[^0-9][A-Za-z0-9`$]\+\>" contains=mmaOperator,mmaSystemSymbol,mmaBrackets
syntax match mmaSymbol "\~\s*[^~]\+\s*\~"ms=s+1,me=e-1 contains=mmaOperator,mmaSystemSymbol,mmaBrackets
syntax match mmaSymbol "//\s*[A-Za-z0-9`$]\+"ms=s+2 contains=mmaOperator,mmaSystemSymbol,mmaBrackets

"Comments and TODOs
syntax keyword mmaTodo TODO FIX FIXME BUG contained
syntax region mmaComment start=+(\*+ end=+\*)+ skipempty contains=mmaComment, mmaTodo

"Strings
syntax region mmaString start=+"+ skip=+\(\\\)\@<!\\"+ end=+"+ skipempty

"Numbers
syntax match mmaNumber "\<\%(\d\+\.\=\d*\|\d*\.\=\d\+\)\>"
syntax match mmaNumber "\d\+`\d*\%(\d\@!\.\|\>\)"
syntax match mmaNumber "[A-Za-z]\+`\d\+\%(\d\@!\.\|\>\)" contains=mmaSymbol,mmaSystemSymbol

"Slots & Slotsequences
syntax match mmaSlot "#\%(#\d*\|\d\+\)\="
syntax match mmaSlot "#\%([A-Za-z0-9`$]*\)"

"Patterns
syntax match mmaPattern "[A-Za-z0-9`$]*_\{1,3}\%([A-Za-z0-9`$]\+\)\="
syntax match mmaPatternName "[A-Za-z0-9`$]\+\s*:[^:=>]"me=e-2
syntax match mmaPattern "[A-Za-z0-9`]*_\+\%([A-Za-z0-9`]\+\)"

"Brackets
syntax match mmaBrackets "[({[}\])]" contained
syntax match mmaBrackets "\%(<|\||>\)" contained

"OPERATORS
"Apply, Postfix, MapAll, ReplaceRepeated
syntax match mmaOperator "\%(@\{1,3}\|//[.@]\=\)"
"Condition, TagSet*, UpSet*, Map, ReplaceAll
syntax match mmaOperator "\%(/[;:@.]\=\|\^\=:\==\)"
"Rule, RuleDelayed
syntax match mmaOperator "\%([-:]\=>\|<=\=\)"
"SubtractFrom, AddTo, TimesBy, DivideBy
syntax match mmaOperator "[-+*/]="
"Plus, Subtract, Times, Divide, Power, Optional/Default, PatternTest
syntax match mmaOperator "[*+=^/.:?-]"
"Infix, StringExpression
syntax match mmaOperator "\%(\~\~\=\)"
"Equal, SameQ, UnsameQ,
syntax match mmaOperator "\%(=\{2,3}\|=\=!=\|||\=\|&&\|!\)"
"Composition, RightComposition
syntax match mmaOperator "\%(@\*\|\/\*\)"

"Special characters
syntax match mmaSpecial "\\\[[A-Za-z0-9]\+\]"

"Messages
syntax match mmaMessage "::\s*[A-Za-z0-9]\+"hs=s+2

"Highlighting
if version >= 508 || !exists("did_mma_syn_inits")
	if version < 508
		let did_mma_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	if exists("g:mma_highlight_option")
		if g:mma_highlight_option == "default"
			"TODO implement default FE colors
		elseif g:mma_highlight_option == "solarized"
			HiLink mmaComment      Comment
			HiLink mmaSymbol       Function
			HiLink mmaSystemSymbol Normal
			HiLink mmaOperator     Normal
			HiLink mmaSlot         Operator
			HiLink mmaString       String
			HiLink mmaSpecial      Function
			HiLink mmaNumber       Normal
			HiLink mmaPattern      Operator
			HiLink mmaPatternName  Operator
			HiLink mmaError        Error
			HiLink mmaBracket      Normal
			HiLink mmaTodo         Todo
			HiLink mmaMessage      Type
		endif
	else
		HiLink mmaComment      Comment
		HiLink mmaSymbol       Normal
		HiLink mmaSystemSymbol Function
		HiLink mmaOperator     Operator
		HiLink mmaSlot         Operator
		HiLink mmaString       String
		HiLink mmaSpecial      Normal
		HiLink mmaNumber       Number
		HiLink mmaPattern      Type
		HiLink mmaPatternName  Type
		HiLink mmaBracket      Normal
		HiLink mmaTodo         Todo
		HiLink mmaMessage      Type
	endif

	delcommand HiLink
endif
let b:current_syntax = "mma"

let &cpo = s:cpo_save
unlet s:cpo_save

endif
