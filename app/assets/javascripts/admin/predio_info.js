var EDIT_URL = '/predios/{:predio_id}/info_predio/{:id}/edit';
var STATS_URL = '/predios/{:predio_id}/charts';
var NOTIFICATION_TEMPLATE =
    '<div class = "row"><div class = "col-md-12"><button type = "button" class="close" aria-label = "Close"><span aria-hidden = "true" > &times; </span> </button> </div> </div> <div class = "otro_pago" >' +
    '<div class="row form-group">\n' +
    '<div class="col-md-4 text-right">\n' +
    '<label> Pago </label>\n' +
    '</div>\n' +
    '<div class="col-md-8 text-left">\n' +
    '<input type="text" name="otro_pago[]" id="otro_pago_1" class="form-control" value="{:nombre_pago}"  readonly="readonly">\n' +
    '</div>\n' +
    '</div>\n' +
    '<div class="row">\n' +
    '<div class="col-md-4 text-right">\n' +
    '<label> Precio </label>\n' +
    '</div>\n' +
    '<div class="col-md-8 text-left">\n' +
    '<input type="text" name="otro_pago_precio[]" id="otro_pago_precio_1" class="form-control" value="{:price_pago}" readonly="readonly" >\n' +
    '</div>\n' +
    '</div>\n' +
    '<hr>' +
    '</div>';

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

    //Initialize date picker
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
            $(this).prop('readonly', true);
        } else {
            var price = this.getAttribute('data-price');
            var estimated_price = (price * this.value);
            var id = this.getAttribute('id');
            $('.' + id).text('$' + estimated_price);
        }
    });

    //Event listener input numbers
    $('.number-materials').change(function() {
        if (this.getAttribute('value') === this.value) {
            // setting the original 'lastvalue' data property
            $(this).data('lastvalue', this.value);
        } else {
            $(this).data('lastvalue', this.value);

            if (this.value) {
                var price = this.getAttribute('data-price');
                var estimated_price = (price * this.value);
                var id = this.getAttribute('id');
                $('.' + id).text('$' + estimated_price);
            }
        }
    }).change();

    //Calculate precio info predio
    $(document).on('blur', '#info_predio_precio', function() {
        var precio = $(this).val();
        var racimos = ($('#info_predio_conteo_racimos').val()) ? $('#info_predio_conteo_racimos').val() : 0;

        if (!isNaN(precio) && !isNaN(racimos)) {
            var venta = precio * racimos;
            $('#info_predio_venta').val(venta);
        }
    });

    //Validations
    onlyNumbers();
    onlyPrice();

    //Remove
    $(document).on('click', '.close', function() {
        var containerOtroPago = $(this).parent().parent().next('.otro_pago');
        var idRemoved = containerOtroPago.attr('data-id');
        containerOtroPago.remove();
        $(this).remove();
        if (typeof idRemoved !== 'undefined') {
            $('#container-pagos').append('<input type="hidden" name="otros_pagos_removed[]" class="otros_pagos_hidden" value="' + idRemoved + '">');
        }
    });
});

function onlyNumbers() {
    $('.onlyNumbers').keyup(function(e) {
        if (/\D/g.test(this.value)) {
            // Filter non-digits from input value.
            this.value = this.value.replace(/\D/g, '');
        }
    });
}

function onlyPrice() {
    $('.onlyPrice')
        .keypress(function(event) {
            if ((event.which != 46 || (event.which == 46 && $(this).val() == '') || $(this)
                    .val()
                    .indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                event.preventDefault();
            }
        })
        .on('paste', function(event) {
            event.preventDefault();
        });
}

function operateFormatterEmail(value, row, index) {
    return ['<div class="table-icons">',
        '<a rel="tooltip" title="Edit" class="btn btn-simple btn-warning btn-icon table-action edit" href="javascript:void(0)" style="margin: 5px">',
        '<i class="glyphicon glyphicon-pencil"></i>',
        '</a>',
        '<a rel="tooltip" title="Stats" class="btn btn-simple btn-primary btn-icon table-action stat" href="javascript:void(0)" style="margin: 5px">',
        '<i class="fa fa-line-chart"></i>',
        '</a>'
    ].join('');
}
//icons operations
window.operateEventsEmail = {
    'click .edit': function(e, value, row, index) {
        EDIT_URL = EDIT_URL.replace('{:id}', row.id).replace('{:predio_id}', row.predio_id);
        window.location = EDIT_URL;
    },
    'click .stat': function(e, value, row, index) {
        STATS_URL = STATS_URL.replace('{:predio_id}', row.predio_id);
        window.location = STATS_URL;
    }
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