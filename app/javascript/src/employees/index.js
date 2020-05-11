var $ = require('jquery');
require('datatables.net');
require('datatables.net-dt/css/jquery.dataTables');

// turbolink を使う場合、jQuery の ready は正常に動作しない
$(document).on('turbolinks:load', function() {
    let form = document.getElementById('employee-index');
    if (form === null) {
        return;
    }

    function onSubmitForm(event) {
        event.preventDefault();
        event.stopPropagation();
    
        // actionを動的に書き換え
        let empId = $("input[name='id']:checked").val();
        window.location = `/employees/${empId}/edit`;
        return true;
    }

    // 従業員の編集ボタンは対象が選択されているときだけ押せるよう有効・無効を切り替える
    function enable_edit_employee_button() {
        let checkedId = $("input[name='id']:checked");
        if (checkedId.length === 0) {
            $("input[type='submit']").prop("disabled", true);
        } else {
            $("input[type='submit']").prop("disabled", false);
        }
    }

    $('table').DataTable( {
        initComplete: function () {
            this.api().columns().every( function () {
                var column = this;
                var select = $('<input value="" />')
                    .appendTo( $(column.footer()).empty() )
                    .on( 'change keydown keyup', function () {
                        var val = $.fn.dataTable.util.escapeRegex(
                            $(this).val()
                        );

                        column
                            .search( val ? val : '', true, false )
                            .draw();
                    } );

                column.data().unique().sort().each( function ( d, j ) {
                    select.append( '<option value="'+d+'">'+d+'</option>' )
                } );
            } );
        }
    } );

    $("form").submit(function(event) {
        onSubmitForm(event);
    });

    $("input[name='id']").change(function() {
        enable_edit_employee_button();
    });

    enable_edit_employee_button();
} );
