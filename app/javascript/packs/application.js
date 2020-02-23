// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import $ from 'jquery'
import 'jquery-ui'
import 'jquery-ui/ui/widgets/sortable'
import 'jquery-ui/ui/disable-selection'
//require("jquery-ui/ui/widgets/sortable")

document.addEventListener("turbolinks:load", () => {
  console.log($("table tbody.sortable").length)
  $("table tbody.sortable").sortable({
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
        console.log($(this).sortable('serialize'))
        $.post($(this).data('sort-url'), $(this).sortable('serialize'))
      }
  }).disableSelection()
})
/*
*/

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
