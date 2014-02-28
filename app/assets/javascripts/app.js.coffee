$(document).on "page:change", ->
  setTimeout ->
    $("table.table-condensed.table-striped.table").fixedHeaderTable
      footer: false
      cloneHeadToFoot: false
      fixedColumn: true
      height: "#{$(window).height() - 250}"
      width: "#{$(window).width() - 400}"
      fixedColumns: 2
  , 500


  $("#table-list").on 'change', (e) ->
    url = $(e.target).data("url") + "/#{$(e.target).val()}"
    Turbolinks.visit url
