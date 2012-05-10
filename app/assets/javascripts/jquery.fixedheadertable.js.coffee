(($) ->
  $.fn.fixedHeaderTable = (method) ->
    defaults =
      width: "100%"
      height: "100%"
      themeClass: "fht-default"
      borderCollapse: true
      fixedColumns: 0
      fixedColumn: false
      sortable: false
      autoShow: true
      footer: false
      cloneHeadToFoot: false
      autoResize: false
      create: null

    settings = {}
    methods =
      init: (options) ->
        settings = $.extend({}, defaults, options)
        @each ->
          $self = $(this)
          self = this
          if helpers._isTable($self)
            methods.setup.apply this, Array::slice.call(arguments, 1)
            $.isFunction(settings.create) and settings.create.call(this)
          else
            $.error "Invalid table mark-up"

      setup: (options) ->
        $self = $(this)
        self = this
        $thead = $self.find("thead")
        $tfoot = $self.find("tfoot")
        $tbody = $self.find("tbody")
        $wrapper = undefined
        $divHead = undefined
        $divFoot = undefined
        $divBody = undefined
        $fixedHeadRow = undefined
        $temp = undefined
        tfootHeight = 0
        settings.originalTable = $(this).clone()
        settings.includePadding = helpers._isPaddingIncludedWithWidth()
        settings.scrollbarOffset = helpers._getScrollbarWidth()
        settings.themeClassName = settings.themeClass
        if settings.width.search("%") > -1
          widthMinusScrollbar = $self.parent().width() - settings.scrollbarOffset
        else
          widthMinusScrollbar = settings.width - settings.scrollbarOffset
        $self.css width: widthMinusScrollbar
        unless $self.closest(".fht-table-wrapper").length
          $self.addClass "fht-table"
          $self.wrap "<div class=\"fht-table-wrapper\"></div>"
        $wrapper = $self.closest(".fht-table-wrapper")
        settings.fixedColumns = 1  if settings.fixedColumn is true and settings.fixedColumns <= 0
        if settings.fixedColumns > 0 and $wrapper.find(".fht-fixed-column").length is 0
          $self.wrap "<div class=\"fht-fixed-body\"></div>"
          $fixedColumns = $("<div class=\"fht-fixed-column\"></div>").prependTo($wrapper)
          $fixedBody = $wrapper.find(".fht-fixed-body")
        $wrapper.css(
          width: settings.width
          height: settings.height
        ).addClass settings.themeClassName
        $self.wrap "<div class=\"fht-tbody\"></div>"  unless $self.hasClass("fht-table-init")
        $divBody = $self.closest(".fht-tbody")
        tableProps = helpers._getTableProps($self)
        helpers._setupClone $divBody, tableProps.tbody
        unless $self.hasClass("fht-table-init")
          if settings.fixedColumns > 0
            $divHead = $("<div class=\"fht-thead\"><table class=\"fht-table\"></table></div>").prependTo($fixedBody)
          else
            $divHead = $("<div class=\"fht-thead\"><table class=\"fht-table\"></table></div>").prependTo($wrapper)
          $divHead.find("table.fht-table").addClass settings.originalTable.attr("class")
          $thead.clone().appendTo $divHead.find("table")
        else
          $divHead = $wrapper.find("div.fht-thead")
        helpers._setupClone $divHead, tableProps.thead
        $self.css "margin-top": -$divHead.outerHeight(true)
        if settings.footer is true
          helpers._setupTableFooter $self, self, tableProps
          $tfoot = $wrapper.find("div.fht-tfoot table")  unless $tfoot.length
          tfootHeight = $tfoot.outerHeight(true)
        tbodyHeight = $wrapper.height() - $thead.outerHeight(true) - tfootHeight - tableProps.border
        $divBody.css height: tbodyHeight
        $self.addClass "fht-table-init"
        methods.altRows.apply self  if typeof (settings.altClass) isnt "undefined"
        helpers._setupFixedColumn $self, self, tableProps  if settings.fixedColumns > 0
        $wrapper.hide()  unless settings.autoShow
        helpers._bindScroll $divBody, tableProps
        self

      resize: (options) ->
        $self = $(this)
        self = this
        self

      altRows: (arg1) ->
        $self = $(this)
        self = this
        altClass = (if (typeof (arg1) isnt "undefined") then arg1 else settings.altClass)
        $self.closest(".fht-table-wrapper").find("tbody tr:odd:not(:hidden)").addClass altClass

      show: (arg1, arg2, arg3) ->
        $self = $(this)
        self = this
        $wrapper = $self.closest(".fht-table-wrapper")
        if typeof (arg1) isnt "undefined" and typeof (arg1) is "number"
          $wrapper.show arg1, ->
            $.isFunction(arg2) and arg2.call(this)

          return self
        else if typeof (arg1) isnt "undefined" and typeof (arg1) is "string" and typeof (arg2) isnt "undefined" and typeof (arg2) is "number"
          $wrapper.show arg1, arg2, ->
            $.isFunction(arg3) and arg3.call(this)

          return self
        $self.closest(".fht-table-wrapper").show()
        $.isFunction(arg1) and arg1.call(this)
        self

      hide: (arg1, arg2, arg3) ->
        $self = $(this)
        self = this
        $wrapper = $self.closest(".fht-table-wrapper")
        if typeof (arg1) isnt "undefined" and typeof (arg1) is "number"
          $wrapper.hide arg1, ->
            $.isFunction(arg3) and arg3.call(this)

          return self
        else if typeof (arg1) isnt "undefined" and typeof (arg1) is "string" and typeof (arg2) isnt "undefined" and typeof (arg2) is "number"
          $wrapper.hide arg1, arg2, ->
            $.isFunction(arg3) and arg3.call(this)

          return self
        $self.closest(".fht-table-wrapper").hide()
        $.isFunction(arg3) and arg3.call(this)
        self

      destroy: ->
        $self = $(this)
        self = this
        $wrapper = $self.closest(".fht-table-wrapper")
        $self.insertBefore($wrapper).removeAttr("style").append($wrapper.find("tfoot")).removeClass("fht-table fht-table-init").find(".fht-cell").remove()
        $wrapper.remove()
        self

    helpers =
      _isTable: ($obj) ->
        $self = $obj
        hasTable = $self.is("table")
        hasThead = $self.find("thead").length > 0
        hasTbody = $self.find("tbody").length > 0
        return true  if hasTable and hasThead and hasTbody
        false

      _bindScroll: ($obj, tableProps) ->
        $self = $obj
        $wrapper = $self.closest(".fht-table-wrapper")
        $thead = $self.siblings(".fht-thead")
        $tfoot = $self.siblings(".fht-tfoot")
        $self.bind "scroll", ->
          if settings.fixedColumns > 0
            $fixedColumns = $wrapper.find(".fht-fixed-column")
            $fixedColumns.find(".fht-tbody table").css "margin-top": -$self.scrollTop()
          $thead.find("table").css "margin-left": -@scrollLeft
          $tfoot.find("table").css "margin-left": -@scrollLeft  if settings.footer or settings.cloneHeadToFoot

      _fixHeightWithCss: ($obj, tableProps) ->
        if settings.includePadding
          $obj.css height: $obj.height() + tableProps.border + 1
        else
          $obj.css height: $obj.parent().height() + tableProps.border + 1

      _fixWidthWithCss: ($obj, tableProps, width) ->
        if settings.includePadding
          $obj.each (index) ->
            $(this).css width: (if width is `undefined` then $(this).width() + tableProps.border else width + tableProps.border)
        else
          $obj.each (index) ->
            $(this).css width: (if width is `undefined` then $(this).parent().width() + tableProps.border else width + tableProps.border)

      _setupFixedColumn: ($obj, obj, tableProps) ->
        $self = $obj
        self = obj
        $wrapper = $self.closest(".fht-table-wrapper")
        $fixedBody = $wrapper.find(".fht-fixed-body")
        $fixedColumn = $wrapper.find(".fht-fixed-column")
        $thead = $("<div class=\"fht-thead\"><table class=\"fht-table\"><thead><tr></tr></thead></table></div>")
        $tbody = $("<div class=\"fht-tbody\"><table class=\"fht-table\"><tbody></tbody></table></div>")
        $tfoot = $("<div class=\"fht-tfoot\"><table class=\"fht-table\"><tfoot><tr></tr></tfoot></table></div>")
        $firstThChildren = undefined
        $firstTdChildren = undefined
        fixedColumnWidth = undefined
        fixedBodyWidth = $wrapper.width()
        fixedBodyHeight = $fixedBody.find(".fht-tbody").height() - settings.scrollbarOffset
        $newRow = undefined
        $thead.find("table.fht-table").addClass settings.originalTable.attr("class")
        $tbody.find("table.fht-table").addClass settings.originalTable.attr("class")
        $tfoot.find("table.fht-table").addClass settings.originalTable.attr("class")
        $firstThChildren = $fixedBody.find(".fht-thead thead tr > *:lt(" + settings.fixedColumns + ")")
        fixedColumnWidth = settings.fixedColumns * tableProps.border
        $firstThChildren.each (index) ->
          fixedColumnWidth += $(this).outerWidth(true)

        helpers._fixHeightWithCss $firstThChildren, tableProps
        helpers._fixWidthWithCss $firstThChildren, tableProps
        tdWidths = []
        $firstThChildren.each (index) ->
          tdWidths.push $(this).width()

        firstTdChildrenSelector = "tbody tr > *:not(:nth-child(n+" + (settings.fixedColumns + 1) + "))"
        $firstTdChildren = $fixedBody.find(firstTdChildrenSelector).each((index) ->
          helpers._fixHeightWithCss $(this), tableProps
          helpers._fixWidthWithCss $(this), tableProps, tdWidths[index % settings.fixedColumns]
        )
        $thead.appendTo($fixedColumn).find("tr").append $firstThChildren.clone()
        $tbody.appendTo($fixedColumn).css
          "margin-top": 0
          height: fixedBodyHeight + tableProps.border

        $newRow = undefined
        $firstTdChildren.each (index) ->
          if index % settings.fixedColumns is 0
            $newRow = $("<tr></tr>").appendTo($tbody.find("tbody"))
            $newRow.addClass settings.altClass  if settings.altClass and $(this).parent().hasClass(settings.altClass)
          $(this).clone().appendTo $newRow

        $fixedColumn.css
          height: 0
          width: fixedColumnWidth

        maxTop = $fixedColumn.find(".fht-tbody .fht-table").height() - $fixedColumn.find(".fht-tbody").height()
        $fixedColumn.find(".fht-table").bind "mousewheel", (event, delta, deltaX, deltaY) ->
          return  if deltaY is 0
          top = parseInt($(this).css("marginTop"), 10) + (if deltaY > 0 then 120 else -120)
          top = 0  if top > 0
          top = -maxTop  if top < -maxTop
          $(this).css "marginTop", top
          $fixedBody.find(".fht-tbody").scrollTop(-top).scroll()
          false

        $fixedBody.css width: fixedBodyWidth
        if settings.footer is true or settings.cloneHeadToFoot is true
          $firstTdFootChild = $fixedBody.find(".fht-tfoot tr > *:lt(" + settings.fixedColumns + ")")
          helpers._fixHeightWithCss $firstTdFootChild, tableProps
          $tfoot.appendTo($fixedColumn).find("tr").append $firstTdFootChild.clone()
          footwidth = $tfoot.find("table").innerWidth()
          $tfoot.css
            top: settings.scrollbarOffset
            width: footwidth

      _setupTableFooter: ($obj, obj, tableProps) ->
        $self = $obj
        self = obj
        $wrapper = $self.closest(".fht-table-wrapper")
        $tfoot = $self.find("tfoot")
        $divFoot = $wrapper.find("div.fht-tfoot")
        unless $divFoot.length
          if settings.fixedColumns > 0
            $divFoot = $("<div class=\"fht-tfoot\"><table class=\"fht-table\"></table></div>").appendTo($wrapper.find(".fht-fixed-body"))
          else
            $divFoot = $("<div class=\"fht-tfoot\"><table class=\"fht-table\"></table></div>").appendTo($wrapper)
        $divFoot.find("table.fht-table").addClass settings.originalTable.attr("class")
        switch true
          when not $tfoot.length and settings.cloneHeadToFoot is true and settings.footer is true
            $divHead = $wrapper.find("div.fht-thead")
            $divFoot.empty()
            $divHead.find("table").clone().appendTo $divFoot
          when $tfoot.length and settings.cloneHeadToFoot is false and settings.footer is true
            $divFoot.find("table").append($tfoot).css "margin-top": -tableProps.border
            helpers._setupClone $divFoot, tableProps.tfoot

      _getTableProps: ($obj) ->
        tableProp =
          thead: {}
          tbody: {}
          tfoot: {}
          border: 0

        borderCollapse = 1
        borderCollapse = 2  if settings.borderCollapse is true
        tableProp.border = ($obj.find("th:first-child").outerWidth() - $obj.find("th:first-child").innerWidth()) / borderCollapse
        $obj.find("thead tr:first-child > *").each (index) ->
          width = null
          width = window.firstColumnWidth  if index < settings.fixedColumns
          count_width = $(this).width() + tableProp.border
          tableProp.thead[index] = width or count_width

        $obj.find("tfoot tr:first-child > *").each (index) ->
          width = null
          width = window.firstColumnWidth  if index < settings.fixedColumns
          count_width = $(this).width() + tableProp.border
          tableProp.tfoot[index] = width or count_width

        $obj.find("tbody tr:first-child > *").each (index) ->
          width = null
          width = window.firstColumnWidth  if index < settings.fixedColumns
          count_width = $(this).width() + tableProp.border
          tableProp.tbody[index] = width or count_width

        tableProp

      _setupClone: ($obj, cellArray) ->
        $self = $obj
        selector = (if ($self.find("thead").length) then "thead tr:first-child > *" else (if ($self.find("tfoot").length) then "tfoot tr:first-child > *" else "tbody tr:first-child > *"))
        $cell = undefined
        $self.find(selector).each (index) ->
          $cell = (if ($(this).find("div.fht-cell").length) then $(this).find("div.fht-cell") else $("<div class=\"fht-cell\"></div>").appendTo($(this)))
          $cell.css width: parseInt(cellArray[index])
          if not $(this).closest(".fht-tbody").length and $(this).is(":last-child") and not $(this).closest(".fht-fixed-column").length
            padding = (($(this).innerWidth() - $(this).width()) / 2) + settings.scrollbarOffset
            $(this).css "padding-right": padding + "px"

      _isPaddingIncludedWithWidth: ->
        $obj = $("<table class=\"fht-table\"><tr><td style=\"padding: 10px; font-size: 10px;\">test</td></tr></table>")
        defaultHeight = undefined
        newHeight = undefined
        $obj.addClass settings.originalTable.attr("class")
        $obj.appendTo "body"
        defaultHeight = $obj.find("td").height()
        $obj.find("td").css "height", $obj.find("tr").height()
        newHeight = $obj.find("td").height()
        $obj.remove()
        unless defaultHeight is newHeight
          true
        else
          false

      _getScrollbarWidth: ->
        scrollbarWidth = 0
        unless scrollbarWidth
          if $.browser.msie
            $textarea1 = $("<textarea cols=\"10\" rows=\"2\"></textarea>").css(
              position: "absolute"
              top: -1000
              left: -1000
            ).appendTo("body")
            $textarea2 = $("<textarea cols=\"10\" rows=\"2\" style=\"overflow: hidden;\"></textarea>").css(
              position: "absolute"
              top: -1000
              left: -1000
            ).appendTo("body")
            scrollbarWidth = $textarea1.width() - $textarea2.width() + 2
            $textarea1.add($textarea2).remove()
          else
            $div = $("<div />").css(
              width: 100
              height: 100
              overflow: "auto"
              position: "absolute"
              top: -1000
              left: -1000
            ).prependTo("body").append("<div />").find("div").css(
              width: "100%"
              height: 200
            )
            scrollbarWidth = 100 - $div.width()
            $div.parent().remove()
        scrollbarWidth

    if methods[method]
      methods[method].apply this, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method
      methods.init.apply this, arguments
    else
      $.error "Method \"" + method + "\" does not exist in fixedHeaderTable plugin!"
) jQuery