var EDIT_URL = '/predios/{:predio_id}/info_predio/{:id}/edit';
var NOTIFICATION_TEMPLATE =
    '<div class="row form-group">\n' +
    '<div class="col-md-4 text-right">\n' +
    '<label> Pago </label>\n' +
    '</div>\n' +
    '<div class="col-md-8 text-left">\n' +
    '<input type="text" name="otro_pago[]" id="otro_pago_1" class="form-control" value="{:nombre_pago}"  >\n' +
    '</div>\n' +
    '</div>\n' +
    '<div class="row">\n' +
    '<div class="col-md-4 text-right">\n' +
    '<label> Precio </label>\n' +
    '</div>\n' +
    '<div class="col-md-8 text-left">\n' +
    '<input type="text" name="otro_pago_precio[]" id="otro_pago_precio_1" class="form-control" value="{:price_pago}" >\n' +
    '</div>\n' +
    '</div>\n' +
    '<hr>';

// Default Type
$(document).ready(function() {
    $(document).on('click', '#add-otros-pagos', function() {
        $('#exampleModal').modal('show');
    });

    $(document).on('click', '#save-payment', function() {
        addOtherPayment();
    });

    // Initialize responses table
    initBootstrapTable();
});

function operateFormatterEmail(value, row, index) {
    return ['<div class="table-icons">', '<a rel="tooltip" title="Edit" class="btn btn-simple btn-warning btn-icon table-action edit" href="javascript:void(0)">', '<i class="glyphicon glyphicon-pencil"></i>', '</a>', '<a rel="tooltip" title="Remove" class="btn btn-simple btn-danger btn-icon table-action remove" href="javascript:void(0)">', '<i class="glyphicon glyphicon-remove"></i>', '</a>', '</div>'].join('');
};


/**
 * Initialize Bootstrap table
 */
function initBootstrapTable() {
    console.log('init');
    $('#info-predio-table').bootstrapTable({
        toolbar: ".toolbar",
        clickToSelect: true,
        showRefresh: false,
        search: false,
        showToggle: false,
        showColumns: false,
        pagination: true,
        searchAlign: 'left',
        pageSize: 10,
        pageList: [],

        formatRecordsPerPage: function(pageNumber) {
            return pageNumber + " rows visible";
        },
        icons: {
            refresh: 'fa fa-refresh',
            toggle: 'fa fa-th-list',
            columns: 'fa fa-columns',
            detailOpen: 'fa fa-plus-circle',
            detailClose: 'ti-close'
        },
        hideColumn: 'id'
    });

    $('#info-predio-table').bootstrapTable('hideColumn', 'id');
    $('#info-predio-table').bootstrapTable('hideColumn', 'predio_id');


    //icons operations
    window.operateEventsEmail = {
        'click .edit': function(e, value, row, index) {
            console.log(row);
            EDIT_URL = EDIT_URL.replace('{:id}', row.id).replace('{:predio_id}', row.predio_id);
            window.location = DETAIL_URL;
        },
        'click .remove': function(e, value, row, index) {

        }
    };
}

function addOtherPayment() {
    var valuePago = $('#otroPago')
        .find('#txtNombre')
        .val();
    var valuePrice = $('#otroPago')
        .find('#txtPrecio')
        .val();

    var other_payment = NOTIFICATION_TEMPLATE.replace('{:nombre_pago}', valuePago).replace('{:price_pago}', valuePrice);

    $('#container-pagos').append(other_payment);


    $('#exampleModal').modal('hide');
    $('#otroPago')
        .find('#txtNombre')
        .val('');
    $('#otroPago')
        .find('#txtPrecio')
        .val('');
}