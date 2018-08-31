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

window.Predio = (function($) {
    var self = {};
    var EDIT_URL = '/predios/{:predio_id}/info_predio/{:id}/edit';
    var STATS_URL = '/predios/{:predio_id}/charts';

    // Initialize
    self.init = function() {
        // Default Type
        $(document).ready(function () {

            // Initialize responses table
            initBootstrapTable();

            //Initialize date picker
            var dateInit = $('#info_predio_fecha_embarque_hd').val();
            $('.fecha_embarque').datetimepicker({
                format: 'DD/MM/YYYY',
                date: dateInit,
            });

            //Validations
            onlyNumbers();
            onlyPrice();

            //Validate predio Form
            $(document).on('click', '#savePredioInfo', function () {
                saveForm();
            });

            // Calculate ratio * racimos
            $(document).on('change', '#ratio-convert', calculateRatio);
            $('#info_predio_conteo_racimos').blur(function() {
                calculateRatio();
            });

            //Calculate venta info predio
            $('#info_predio_precio').blur(calculateSale);

            //Disabled if not stock
            $('.number-materials').each(function () {
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
            $('.number-materials').change(function () {
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

            OtrosPagos.init();
            Workers.init();

        });
    };

    /**
     * Initialize Bootstrap table
     */
    function initBootstrapTable() {
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
            formatRecordsPerPage: function (pageNumber) {
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
            'click .edit': function (e, value, row, index) {
                EDIT_URL = EDIT_URL.replace('{:id}', row.id).replace('{:predio_id}', row.predio_id);
                window.location = EDIT_URL;
            },
            'click .stat': function (e, value, row, index) {
                STATS_URL = STATS_URL.replace('{:predio_id}', row.predio_id);
                window.location = STATS_URL;
            }
        };
    }

    function onlyNumbers() {
        $('.onlyNumbers').keyup(function (e) {
            if (/\D/g.test(this.value)) {
                // Filter non-digits from input value.
                this.value = this.value.replace(/\D/g, '');
            }
        });
    }

    function onlyPrice() {
        $('.onlyPrice')
            .keypress(function (event) {
                if ((event.which != 46 || (event.which == 46 && $(this).val() == '') || $(this)
                    .val()
                    .indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                    event.preventDefault();
                }
            })
            .on('paste', function (event) {
                event.preventDefault();
            });
    }



    function calculateSale() {
        var precio = $('#info_predio_precio').val();
        var cajas = ($('#info_predio_cajas').val()) ? $('#info_predio_cajas').val() : 0;

        if (!isNaN(precio) && !isNaN(cajas)) {
            var venta = precio * cajas;
            venta = Number(venta).toFixed(2);
            $('#info_predio_venta').val(venta);
        }
    }

    function calculateRatio() {
        var ratio = $('#ratio-convert').find(':selected').val();
        var conteoRacimos = $('#info_predio_conteo_racimos').val();

        if(!isNaN(conteoRacimos)) {
            var cajas = Math.round(ratio * conteoRacimos);
            $('#info_predio_cajas').val(cajas)
            calculateSale();
        }
    }

    function saveForm() {
        $('.info_predio_form').validate();
    }

    // Initialize
    self.init();
    return self;
})(jQuery);

window.OtrosPagos = (function($) {
    var self = {};
    var CONTROL_ADD_PAYMENTS = 0;
    var TR_TEMPLATE = '<tr data-id="{:id}">'+
        '<td>\n' +
        '<input type="text" name="otro_pago[]" id="otro_pago_1" class="form-control" value="{:nombre_pago}"  readonly="readonly">\n' +
        '</td>\n' +
        '<td>\n' +
        '<input type="text" name="otro_pago_precio[]" id="otro_pago_precio_1" class="form-control otroPago" value="{:price_pago}" readonly="readonly" >\n' +
        '</td>\n' +
        '<td>\n' +
        '<a href class="btn btn-danger removerOtherPayment" data-row="{:id}" data-price="-{:price_pago}"> <span class="glyphicon glyphicon-remove" aria-hidden="true"></span></a>\n' +
        '</td>\n' +
        '</tr>';
    var TOTAL = 0;

    // Initialize
    self.init = function() {
        $(document).ready(function() {
            //Otros pagos
            $(document).on('click', '#add-otros-pagos', function () {
                $('#exampleModal').modal('show');
            });
            if ($('#notHiddenOtrosPagos').length <= 0) {
                $('#tableOtherPagos').hide();
            }
            //Trigger otro pago and validate
            $(document).on('click', '#save-payment', function () {
                addOtherPayment();
            });
            //Remove payment
            $(document).on('click', '.removerOtherPayment', function(e) {
                e.preventDefault();
                var deleteTr = $(this).data('row');
                var price = $(this).data('price');

                $('#tableOtherPagos tbody tr').each(function(index, value) {
                    var tr = $(value).attr('data-id');
                    if (deleteTr == tr) {
                        $(value).remove();
                        calculateTotalOtrosPagos(price);
                        return false;
                    }
                });

                var trEditRemoved = $(this).closest('tr').attr('data-row');
                if (typeof trEditRemoved !== 'undefined') {
                    $('#container-pagos').append('<input type="hidden" name="otros_pagos_removed[]" class="otros_pagos_hidden" value="' + trEditRemoved + '">');
                }
            });
            calculateTotal();
        });
    };

    function calculateTotal() {
        $('#tableOtherPagos').find('.otroPago').each(function(index, value){
            TOTAL = Number(TOTAL);
            var price = $(value).val();
            price = Number(price);
            TOTAL += price;
            TOTAL = Number(TOTAL).toFixed(2);
        });
        $('.totalOtroPago').text('$' + TOTAL);
    }

    function addOtherPayment() {
        $.validator.addMethod('price', function (value, element) {
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
            submitHandler: function () {
                var valuePago = $('#otroPago')
                    .find('#txtNombre')
                    .val();
                var valuePrice = $('#otroPago')
                    .find('#txtPrecio')
                    .val();

                var other_payment = TR_TEMPLATE.replace('{:nombre_pago}', valuePago)
                    .replace(/{:price_pago}/g, valuePrice)
                    .replace(/{:id}/g, CONTROL_ADD_PAYMENTS);
                $('#tableOtherPagos tbody').append(other_payment);
                calculateTotalOtrosPagos(valuePrice);
                $('#tableOtherPagos').show();

                $('#exampleModal').modal('hide');
                $('#otroPago')
                    .find('#txtNombre')
                    .val('');
                $('#otroPago')
                    .find('#txtPrecio')
                    .val('');
            },
            invalidHandler: function (form, validator) {
                var errors = validator.numberOfInvalids();
                console.log(errors);
                console.log(validator);
                validator.focusInvalid();
            },
        });
    }

    function calculateTotalOtrosPagos(price) {
        price = Number(price);
        TOTAL = Number(TOTAL);
        TOTAL += price;
        TOTAL = Number(TOTAL).toFixed(2);
        $('.totalOtroPago').text('$' + TOTAL);
    }

    return self;
})(jQuery);

window.Workers = (function($) {
    var self = {};
    var CONTROL_ADD_PAYMENTS_WORKERS = 0;
    var TR_TEMPLATE = '<tr data-id="{:id}">'+
        '<td>\n' +
        '<input type="text" name="trabajador[]" id="pago_trabajador_1" class="form-control" value="{:nombre_trabajador}"  readonly="readonly">' +
        '<input type="hidden" name="trabajador_id[]" id="pago_trabajador_1" class="form-control" value="{:id_trabajador}">\n' +
        '</td>\n' +
        '<td>\n' +
        '<input type="text" name="tipo_trabajador[]" id="pago_1" class="form-control price" value="{:tipo_trabajador}" disabled="disabled" >\n' +
        '</td>\n' +
        '<td>\n' +
        '<input type="text" name="pago_trabajador[]" id="pago_1" class="form-control" value="{:price_pago}" readonly="readonly" >\n' +
        '</td>\n' +
        '<td>\n' +
        '<a href class="btn btn-danger removeWorkerPayment" data-tr="{:id}" data-price="-{:price_pago}"> <span class="glyphicon glyphicon-remove" aria-hidden="true"></span></a>\n' +
        '</td>\n' +
        '</tr>';

    // Initialize
    self.init = function() {
        $(document).ready(function() {
            //Add pago trabajadores
            $(document).on('click', '#add-pagos-workers', function () {
                $('#pagoTrabajadoresModal').modal('show');
            });

            if ($('#notHidden').length <= 0) {
                $('#tablePagos').hide();
            }

            //Trigger pago trabajadores and validate
            $(document).on('click', '#save-payment-worker', function () {
                addOtherPaymentWorker();
            });
            //Remove payment
            $(document).on('click', '.removeWorkerPayment', function(e) {
                e.preventDefault();
                var deleteTr = $(this).data('tr');
                var price = $(this).data('price');

                $('#tablePagos tbody tr').each(function(index, value) {
                    var tr = $(value).attr('data-id');
                    if (deleteTr == tr) {
                        $(value).remove();
                        addTotalPagoTrabajador(price);
                        return false;
                    }
                });

                var trEditRemoved = $(this).closest('tr').attr('data-row');
                if (typeof trEditRemoved !== 'undefined') {
                    $('#container-trabajadores').append('<input type="hidden" name="pagos_trabajadores_removed[]" class="otros_pagos_hidden" value="' + trEditRemoved + '">');
                }
            });
        });
    };

    function addOtherPaymentWorker() {
        $.validator.addMethod('price', function (value, element) {
            return this.optional(element) || /^\d+(\.\d{1,2})?$/.test(value);
        }, 'Escribe un precio valido');

        $('#pagoTrabajadoresForm').validate({
            ignore: [],
            rules: {
                worker_id: {
                    required: true
                },
                precioPago: {
                    required: true,
                    price: ['', false],
                },
            },
            messages: {
                worker_id: {
                    required: 'Trabajador es requerido.'
                },
                precioPago: {
                    required: 'El precio del pago es requerido.',
                    price: 'Escribe un precio valido',
                }
            },
            submitHandler: function () {
                CONTROL_ADD_PAYMENTS_WORKERS++;
                var workerId = $('#worker_id')
                    .find(':selected')
                    .val();
                var worker = $('#worker_id')
                    .find(':selected')
                    .text();
                var valuePrice = $('#pagoTrabajadoresForm')
                    .find('#txtPrecio')
                    .val();
                var tipoTrabajador = $('#worker_id')
                    .find(':selected')
                    .data('worker-type');

                var other_payment = TR_TEMPLATE.replace('{:nombre_trabajador}', worker)
                    .replace('{:id_trabajador}', workerId)
                    .replace('{:tipo_trabajador}', (tipoTrabajador) ? tipoTrabajador : 'No definido')
                    .replace(/{:price_pago}/g, valuePrice)
                    .replace(/{:id}/g, CONTROL_ADD_PAYMENTS_WORKERS);
                addTotalPagoTrabajador(valuePrice);
                $('#tablePagos tbody').append(other_payment);

                $('#tablePagos').show();
                $('#pagoTrabajadoresModal').modal('hide');
                $('#pagoTrabajadoresForm')
                    .find('#txtPrecio')
                    .val('');
            },
            invalidHandler: function (form, validator) {
                var errors = validator.numberOfInvalids();
                console.log(errors);
                console.log(validator);
                validator.focusInvalid();
            },
        });
    }

    function addTotalPagoTrabajador(price) {
        var value = $('#pago_trabaja').val();
        value = Number(value);
        price = Number(price)
        value += price;
        value = Number(value).toFixed(2);
        $('#pago_trabaja').val(value);
        $('.totalPagoTrabajo').text('$' + value)
    }

    return self;
})(jQuery);