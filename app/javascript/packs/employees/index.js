var $ = require('jquery');
require('datatables.net');
require('datatables.net-dt/css/jquery.dataTables');

$(document).ready(function() {
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
} );
