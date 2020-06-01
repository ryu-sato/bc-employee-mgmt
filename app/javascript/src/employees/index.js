var $ = require('jquery');
require('datatables.net');
require('datatables.net-dt/css/jquery.dataTables');

// turbolink を使う場合、jQuery の ready は正常に動作しない
$(document).on('turbolinks:load', function () {
  let form = document.getElementById('employee-index');
  if (form === null) {
    return;
  }

  function onSubmitForm(event) {
    event.preventDefault();
    event.stopPropagation();

    // actionを動的に書き換え
    let empIdA = $("input[name='id_a']:checked").val();
    let empIdB = $("input[name='id_b']:checked").val();
    window.location = `/employees/matching?id_a=${empIdA}&id_b=${empIdB}`;
    return true;
  }

  // 従業員の編集ボタンは対象が選択されているときだけ押せるよう有効・無効を切り替える
  function enable_edit_employee_button() {
    let checkedIdA = $("input[name='id_a']:checked");
    let checkedIdB = $("input[name='id_b']:checked");
    if (checkedIdA.length === 1 && checkedIdB.length === 1) {
      $("input[type='submit']").prop("disabled", false);
    } else {
      $("input[type='submit']").prop("disabled", true);
    }
  }

  $('table').DataTable({
    initComplete: function () {
      this.api().columns().every(function () {
        var column = this;
        var select = $('<input value="" />')
          .appendTo($(column.footer()).empty())
          .on('change keydown keyup', function () {
            var val = $.fn.dataTable.util.escapeRegex(
              $(this).val()
            );

            column
              .search(val ? val : '', true, false)
              .draw();
          });

        column.data().unique().sort().each(function (d, j) {
          select.append('<option value="' + d + '">' + d + '</option>')
        });
      });
    }
  });

  $("form").submit(function (event) {
    onSubmitForm(event);
  });

  $("input[name*='id_']").change(function () {
    enable_edit_employee_button();
  });

  enable_edit_employee_button();
});
