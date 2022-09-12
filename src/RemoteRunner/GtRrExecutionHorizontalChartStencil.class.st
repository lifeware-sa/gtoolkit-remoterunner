Class {
	#name : #GtRrExecutionHorizontalChartStencil,
	#superclass : #BrStencil,
	#instVars : [
		'executions'
	],
	#category : #'RemoteRunner-UI'
}

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> amountOfTicks [
	^ 6
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> barHeight [
	^ 20
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> create [
	<return: #Object>
	| minCreationDate maxExpireDate scrollableContent plot timeScale barWidthScale |
	
	minCreationDate := self firstStartDate.	
	maxExpireDate := self lastEndDate.
	
	timeScale := GtPlotterTimeScale new 
		domainFrom: minCreationDate to: maxExpireDate.
	timeScale tickFormat: [ :eachDateAndTime | 
		eachDateAndTime asTime print24 ].
	
	barWidthScale := GtPlotterDurationScale new 
		domainFrom: 0 seconds 
		to: maxExpireDate - minCreationDate.
	
	plot := BrVerticalPane new matchParent.

	plot addChild: (GtPlotterHorizontalTickLabelsElement new
		padding: (BlInsets left: self labelWidth + self gridlineOffset);
		scale: timeScale;
		height: self barHeight;
		labels: self amountOfTicks).
	
	scrollableContent := GtPlotterSingleScaleScrollElement new.
	scrollableContent stencil: [ :anExecutionDetails |
		| aRowContainer aLabel theBars |
		
		aRowContainer := self createRow.
		aLabel := self createLabelCell: (
			anExecutionDetails totalCount asString,
			(anExecutionDetails totalCount = 1 ifTrue: [ 'test'] ifFalse: ['tests']),
			' (', anExecutionDetails state, ')  '  ).
		
		theBars := GtPlotterHorizontalValueBarsElement new
			height: self barHeight;
			valueStyle: [ :anElement :aGtScaleContext |
				self styleBar: anElement execution: aGtScaleContext originalValue.
				anElement constraintsDo: [ :c | 
					c frame horizontal 
						alignLeftAt: (timeScale map: aGtScaleContext originalValue startTime) ] ];
			scale: barWidthScale;
			scaleData: [ :each | each duration ];
			values: {anExecutionDetails}.
	
		aRowContainer addChildren: {
			aLabel.
			theBars } ].
	scrollableContent values: self executions.

	scrollableContent addChild: (self createGridlines: timeScale).

	
	plot addChild: scrollableContent.

	^ plot
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> createGridlines: aGtPlotterScale [
	^ GtPlotterHorizontalTicksElement new
		padding: self gridlinePadding;
		preventMeAndChildrenMouseEvents;
		scale: aGtPlotterScale;
		tickStyle: [ :anElement | anElement
			width: self gridlineWidth;
			background: self gridlineColor ];
		ticks: self amountOfTicks
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> createLabel: aString [
	^ BrLabel new
		aptitude:
			(BrGlamorousLabelAptitude new
				foreground: self labelColor);
		padding: (BlInsets right: 5);
		text: aString
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> createLabelCell: aString [
	^ BrVerticalPane new
		matchParent;
		alignCenterRight;
		addChild: (self createLabel: aString);
		hExact: self labelWidth
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> createRow [
	^ BrHorizontalPane new
		vExact: self rowHeight;
		alignCenter;
		hMatchParent
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> executions [

	^ executions
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> executions: anObject [

	executions := anObject
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> firstStartDate [
	^ self executions
		inject: self executions first startTime 
		into: [ :minDate :each | minDate min: each startTime ]
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> gridlineColor [
	^ Color gray alpha: 0.2
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> gridlineOffset [
	^ 10
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> gridlinePadding [
	^ BlInsets left: self labelWidth + self gridlineOffset
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> gridlineWidth [
	^ 1
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> labelColor [
	^ Color gray
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> labelWidth [
	^ 250
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> lastEndDate [
	^ self executions 
		inject: self executions  first endTime 
		into: [ :maxDate :each | maxDate max: each endTime ]
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> rowHeight [
	^ 30
]

{ #category : #accessing }
GtRrExecutionHorizontalChartStencil >> styleBar: anElement execution: anObject [ 
	^ anElement
		geometry: BlStadium new;
		background: ((Color r: 92 g: 204 b: 231 range: 255) alpha: 0.2)
]