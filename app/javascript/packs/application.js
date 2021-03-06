// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// initialize datatables
var $ = require('jquery');
require('datatables.net');
require('datatables.net-dt/css/jquery.dataTables');
// turbolink を使う場合、jQuery の ready は正常に動作しない
$(document).on('turbolinks:load', function () {
  $("table[class*='datatable']").DataTable();
});

// bootstrap
require('bootstrap');
require('bootstrap/scss/bootstrap');
// styling datatable by bs4
require('datatables.net-bs4');

// 各ページ用のjsを読み込む
require('../src/employees/index');

// stylesを読み込む
require('../stylesheets/bc_employee_mgmt.scss');
