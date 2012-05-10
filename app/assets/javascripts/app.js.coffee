$('document').ready ->
 
    $("table.table-condensed.table-striped.table").fixedHeaderTable
      footer: false
      cloneHeadToFoot: false
      fixedColumn: true 
      height: "#{$(window).height() - 300}"
      width: "#{$(window).width() - 400}"
      fixedColumns: 2