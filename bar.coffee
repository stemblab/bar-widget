#!vanilla

Widgets = $blab.Widgets

class Widget
  
  @layoutPreamble:
    "#{@handle} = (id, spec) -> new #{@api}(id, spec)"
    
  @computePreamble:
    "#{@handle} = (id) -> #{@api}.compute(id)"
    
  constructor: (@p1, @p2) ->
    
    if typeof @p1 is "string"
      @id = @p1
      @spec = @p2
      @spec.id = @id
    else
      @spec = @p1
      @id = @spec.id
      
class Bar extends Widget
  
  @handle: "bar"
  @api: "$blab.Widgets.Registry.Bar"
  
  @initSpec: (id) -> """
    width: 300, height: 200
    xlabel: "x", ylabel: "y"
    xaxis: {minTickSize: 1}
    # xaxis: {min: 0, max: 1}
    # yaxis: {min: 0, max: 1}
    series: {bars: {show: true}, stack:true}
    # colors: ["red", "blue"]
    #grid: {backgroundColor: "white"}
  """
  
  @layoutPreamble: "#{@handle} = (id, spec) -> new #{@api}(id, spec)"
  
  @computePreamble: "#{@handle} = (id, v...) ->\n  #{@api}.compute(id, v)\n  null"
  
  @compute: (id, v) ->
    Widgets.fetch(Bar, id, v...)?.setVal(v)
  
  constructor: (@p1, @p2) ->
    
    super @p1, @p2
    
    {@width, @height, @xlabel, @ylabel} = @spec
    
    @plot = $("#"+@id)
    @plot.remove() if @plot.length
    @plot = $ "<div>",
      id: @id
      css:
        width: @width ? 400
        height: @height ? 200
        
    Widgets.append @id, this, @plot
    
  initialize: -> #@setVal @init
    
  setVal: (v) ->
    @plot.empty()
    @value = v
    #@plot.text v
    
    params = @spec
    #params.series.shadowSize ?= 0
    #params.series ?= {color: "#55f"}
    
    params.xaxis ?= {}
    params.yaxis ?= {}
    
    params.xaxis?.axisLabel = params.xlabel if params.xlabel
    params.yaxis?.axisLabel = params.ylabel if params.ylabel
    params.xaxis?.axisLabelUseCanvas ?= true
    params.yaxis?.axisLabelUseCanvas ?= true
    params.xaxis?.axisLabelPadding ?= 10
    params.yaxis?.axisLabelPadding ?= 10

    $.plot @plot, @transformArgs(v), params

  transformArgs: (v) ->

    lol = (u) -> # list of lists
      if u[0]? # array
        if u[0].length?
          z = u
        else
          z = []
          z.push u
      else # not array
        z=[[u]]
      z

    nargin = v.length
    L = []

    # just data, no x-values or labels
    if nargin is 1 
      Y = lol v[0]
      X = ([k] for k in [0...Y.length])
      maxRows =  Math.max(X.length, Y.length)

      # either: (I) x-values & data OR (II) data and labels
    if nargin is 2

      # enforce list of lists ([[],[],...])
      v0 = lol v[0]
      if typeof v[1] is "string" # e.g., just "A"
        v1 = [v[1]]
      else # e.g., ["A", "B"], or [0]
        v1 = lol v[1] 

      if typeof v1[0] is "string" # (II)
        Y = v0 # lol v[0]
        X = ([k] for k in [0...Y.length])
        L = v1
        maxRows =  Y.length
      else # (I)
        X = v0 #lol v[0]
        Y = v1 #lol v[1]
        maxRows =  Math.max(X.length, Y.length)
    
    if nargin is 3
      X = lol v[0]
      Y = lol v[1]
      L = lol v[2]
      maxRows =  Math.max(X.length, Y.length)

    d = []
    for k in [0...maxRows]
      xRow = Math.min(k,X.length-1)
      yRow = Math.min(k,Y.length-1)
      lRow = Math.min(k,L.length-1)
      l = numeric.transpose([X[xRow], Y[yRow]])
      d.push {"data": l, "label":L[lRow]}

    d

Widgets.register [Bar]

