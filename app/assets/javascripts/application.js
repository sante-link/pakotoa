//= require jquery
//= require jquery-ui/widgets/sortable
//= require jquery-ui/disable-selection
//= require jquery_ujs
//= require turbolinks
//= require bootstrap

document.addEventListener("turbolinks:load", () => {
  const selector = "table tbody.sortable"
  console.log($(selector).length)
  $(selector).sortable({
    axis: 'y',
    handle: 'i',
    helper: (e, tr) => {
      var originals = tr.children()
      var helper = tr.clone()
      helper.children().each( (index) => {
        // Set helper cell sizes to match the original sizes
        $(this).width(originals.eq(index).width())
      })
      return helper
    },
    update: () => {
      console.log($(selector).sortable('serialize'))
      $.post($(selector).data('sort-url'), $(selector).sortable('serialize'))
    }
  }).disableSelection()
})
