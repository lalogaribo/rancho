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
    //Append otro pago and validate
    $(document).on('click', '#save-payment', function() {
        addOtherPayment();
    });
    // Initialize responses table
    initBootstrapTable();
    //Initializa date picker
    dateInit = $('#info_predio_fecha_embarque_hd').val();
    $('.fecha_embarque').datetimepicker({
        format: 'DD/MM/YYYY',
        date: dateInit,
    });
    //Validate predio Form
    $(document).on('click', '#savePredioInfo', function() {
        saveForm();
    });

    //Disabled if not stock
    $('.number-materials').each(function() {
        var max = $(this).attr('max');

        if (max <= 0) {
            $(this).prop('disabled', true);
        }
    })


    //Event listener input numbers
    $('.number-materials').change(function() {
        if (this.getAttribute('value') === this.value) {
            // setting the original 'lastvalue' data property
            $(this).data('lastvalue', this.value);
        } else {
            console.log(this.value < $(this).data('lastvalue') ? 'decrement' : 'increment');
            $(this).data('lastvalue', this.value);

            if (this.value) {
                var price = this.getAttribute('data-price')
                var estimated_price = (price * this.value);
                var id = this.getAttribute('id');
                console.log('.' + id);
                $('.' + id).text('$' + estimated_price);
            }
        }
    }).change();
});

function operateFormatterEmail(value, row, index) {
    return ['<div class="table-icons">', '<a rel="tooltip" title="Edit" class="btn btn-simple btn-warning btn-icon table-action edit" href="javascript:void(0)">', '<i class="glyphicon glyphicon-pencil"></i>', '</a>', '<a rel="tooltip" title="Remove" class="btn btn-simple btn-danger btn-icon table-action remove" href="javascript:void(0)">', '<i class="glyphicon glyphicon-remove"></i>', '</a>', '</div>'].join('');
};


function saveForm() {
    $('.info_predio_form').validate();
}

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
    $.validator.addMethod('price', function(value, element) {
        return this.optional(element) || /^\d+(\.\d{1,2})?$/.test(value);
    }, 'Escribe un precio valido');


    $('#otroPago').validate({
        ignore: [],
        rules: {
            nombrePago: {
                required: true,
                maxlength: 100,
            },
            precioPago: {
                required: true,
                price: ['', false],
            },
        },
        messages: {
            nombrePago: {
                required: 'Nombre del pago es requerido.',
                maxlength: 'La longitud maxima es 100 caracteres.',
            },
            precioPago: {
                required: 'El precio del pago es requerido.',
                price: 'Escribe un precio valido',
            }
        },
        submitHandler: function() {
            var valuePago = $('#otroPago')
                .find('#txtNombre')
                .val();
            var valuePrice = $('#otroPago')
                .find('#txtPrecio')
                .val();

            var other_payment = NOTIFICATION_TEMPLATE.replace(
                '{:nombre_pago}',
                valuePago
            ).replace('{:price_pago}', valuePrice);

            $('#container-pagos').append(other_payment);

            $('#exampleModal').modal('hide');
            $('#otroPago')
                .find('#txtNombre')
                .val('');
            $('#otroPago')
                .find('#txtPrecio')
                .val('');
        },
        invalidHandler: function(form, validator) {
            var errors = validator.numberOfInvalids();
            console.log(errors);
            console.log(validator);
            validator.focusInvalid();
        },
    });
}