window.Chart = (function($) {
    var PREDIO_ID = undefined;
    var TITLE_AXIS = 'Semana';
    var NAME_PREDIO = '';
    var EARNINGS = false;
    var TOKEN = undefined;

    // Initialize
    self.init = function() {
        $(document).ready(function() {
            $('.alert').hide();
            google.charts.load('current', {
                'packages': ['corechart' ,'bar']
            });
            // Load if set the predio in URL
            if (predioExist()) {
                Chart.Summary.loadSummary(PREDIO_ID, '');
                $('#filterDate').attr('disabled', false);
            } else {
                $('#filterDate').attr('disabled', true);
            }
            // Load by predio select
            $(document).on('change', '#predio', function() {
                fetchStatsPredio($(this));
                if (!hasTokenChart()) {
                    $("#addUtility").prop( "checked", false );
                }
                $('#filterDate').val(1);
            });
            // Load by date select
            $(document).on('change', '#filterDate', function() {
                fetchStatsPredioByDate($(this));
            });
            // Checkbox trigger modal
            $(document).on('change', '#addUtility', function() {
                var predioSelected = $('#predio').find(':selected').val();
                if ($(this).is(':checked') && (predioExist() || predioSelected)) {
                    $('#filterDate').val(1);
                    $('#authenticationChart').modal('show');
                }
                else {
                    $('#authenticationChart').modal('hide');
                    TOKEN = undefined;
                    EARNINGS = false;
                }
            });
            // Validate token
            $('#generate-chart').click(validateTokenChart);
        });
    };

    function hasTokenChart() {
        if (typeof TOKEN === 'undefined') {
            return false;
        }
        else {
            return true;
        }
    }

    function validateTokenChart() {
        $.validator.addMethod('checkToken', function (value, element) {
            var token = $('#token').val();
            if (token === value) {
                return true;
            }
            else {
                TOKEN = undefined;
                return false;
            }
        }, 'El token es invalido');


        $('#generateChartForm').validate({
            ignore: [],
            rules: {
                tokenChart: {
                    checkToken: true,
                }
            },
            messages: {
                tokenChart: {
                    checkToken: 'El token es invalido',
                }
            },
            submitHandler: function () {
                TOKEN = $('#txtTokenChart').val();
                EARNINGS = true;
                var predioId = $('#predio').find(':selected').val();
                Chart.Earnings.loadEarnings(predioId, '',  TOKEN)
            },
            invalidHandler: function (form, validator) {
                var errors = validator.numberOfInvalids();
                console.log(errors);
                console.log(validator);
                validator.focusInvalid();
            },
        });
    }

    function predioExist() {
        if ($('#hdPredioId').length > 0) {
            PREDIO_ID = $('#hdPredioId').val();
            if ($.isNumeric(PREDIO_ID)) {
                $('#predio').val(PREDIO_ID);
                return true;
            } else {
                return false;
            }
        }
    }

    function fetchStatsPredio(trigger) {
        PREDIO_ID = trigger.find(':selected').val();
        if ($.isNumeric(PREDIO_ID)) {
            $('#filterDate').attr('disabled', false);
            NAME_PREDIO = trigger.find(':selected').text();
            $('.namePredio').text(NAME_PREDIO);
            getChart('')
        }
    }

    function fetchStatsPredioByDate(trigger) {
        var typeFilter = trigger.find(':selected').val();
        if ($.isNumeric(PREDIO_ID)) {
            console.log(typeFilter);
            var type;
            if (typeFilter == '1') {
                type = '';
                TITLE_AXIS = 'Semana';
            } else if (typeFilter == '2') {
                type = '/month';
                TITLE_AXIS = 'Mes';
            } else {
                type = '/year';
                TITLE_AXIS = 'Año';
            }
            getChart(type);
        }
    }

    function getChart(type) {
        if (EARNINGS && hasTokenChart()) {
            Chart.Earnings.loadEarnings(PREDIO_ID, type, TOKEN);
        }
        else{
            Chart.Summary.loadSummary(PREDIO_ID, type);
        }
    }

    self.getTitleAxis = function() {
        return TITLE_AXIS;
    };

    self.getOptionsChart =function() {
        var options = {
            vAxis: {
                format: 'currency'
            },
            hAxis: {
                format: '',
                title: Chart.getTitleAxis()
            },
            height:400,
            width: '100%',
            animation: {
                duration: 1500,
                easing: 'out',
                startup: true
            },
            bar: { groupWidth: '50%' },
            chartArea: {
                width: '80%'
            }
        };

        return options;
    };

    /**
    *
    * @param {Object} xhr
    * @param {String} status
    * @param {String} errorThrown
    */
    self.onError = function(xhr, status, errorThrown) {
        var errorMessage = errorThrown;
        if (typeof xhr.responseJSON === "object" && xhr.responseJSON.hasOwnProperty("error")) {
            errorMessage = xhr.responseJSON.error;
        }
        console.log(errorMessage);
    };

    self.isEmpty = function (obj) {
        for(var key in obj) {
            if(obj.hasOwnProperty(key))
                return false;
        }
        return true;
    };

    self.getNamePredio = function() {
        return NAME_PREDIO;
    };

    // Initialize
    self.init();

    return self;

})(jQuery);

window.Chart.Summary = (function($) {
    var HEADERS = ['Semana','Produccion', 'Ventas', 'Gastos'];
    var VALUES = [];

    self.loadSummary = function(predio_id, type) {
        summary(predio_id, type);
        Chart.Ratio.loadRatio(predio_id, type)
    };

    function summary(predio_id, type) {
        var settings = {
            type: "GET",
            url: '/predios/' + predio_id + '/summary' + type,
            dataType: "json",
            error: Chart.onError,
            success: onSuccess
        };
        return $.ajax(settings);
    }

    function onSuccess(data) {
        if (!Chart.isEmpty(data)) {
            $('.alert').hide();
            $('#filterDate').attr('disabled', false);

            console.log('summary')
            var valuesObj = Object.values(data);
            var keysObj = Object.keys(data);
            VALUES = [];
            if ($.isArray(valuesObj) && $.isArray(keysObj)) {
                VALUES.push(HEADERS);
                $.each(valuesObj, function(indexArray, value) {
                    var reference = [];
                    reference.push(value.semana);
                    reference.push(value.produccion);
                    reference.push(value.venta);
                    reference.push(value.inversion);
                    VALUES.push(reference)
                });
            }
            // Load chart
            $('#barchart_earnings').empty();
            google
                .charts
                .setOnLoadCallback(drawPaymentChart);
        }
        else {
            $('.alert .name-predio').text(Chart.getNamePredio());
            $('#filterDate').attr('disabled', true);
            $('.alert').show();
            $('#barchart_summary').empty();
            $('#barchart_earnings').empty();
            $('#trendline_ratio').empty();
            $('#barchart_sales').empty();
            $('#barchart_investments').empty();
            $('#barchart_materials').empty();
        }
    }

    function drawPaymentChart() {
        var data = google
            .visualization
            .arrayToDataTable(VALUES);

        var tickMarks = [];
        //add first
        tickMarks.push(data.getValue(0, 0));
        //add last
        tickMarks.push(data.getValue(data.getNumberOfRows() - 1, 0));

        var options = Chart.getOptionsChart();
        options.seriesType = 'bars';
        options.series= {5: {type: 'line'}};
        options.title = 'Reporte General',
        options.colors = ['#210f2b', '#428bca', '#d95f02',];
        options.hAxis = {
            format: '',
            title: Chart.getTitleAxis(),
            ticks: tickMarks
        };

        var chart = new google.visualization.ComboChart(document.getElementById('barchart_summary'));
        chart.draw(data, options);
    }

    return self;
})(jQuery);

window.Chart.Earnings = (function($) {
    var HEADERS = ['Semana','Produccion', 'Ventas', 'Gastos', 'Utilidad'];
    var VALUES = [];

    self.loadEarnings = function(predio_id, type, token) {
        earnings(predio_id, type, token);
        Chart.Ratio.loadRatio(predio_id, type)
    };

    function earnings(predio_id, type, token) {
        var settings = {
            type: "GET",
            url: '/predios/' + predio_id + '/' + token + '/earnings' + type,
            dataType: "json",
            error: Chart.onError,
            success: onSuccess
        };
        return $.ajax(settings);
    }

    function onSuccess(data) {
        if (!Chart.isEmpty(data)) {
            $('.alert').hide();
            $('#filterDate').attr('disabled', false);

            var valuesObj = Object.values(data);
            var keysObj = Object.keys(data);
            VALUES = [];
            if ($.isArray(valuesObj) && $.isArray(keysObj)) {
                VALUES.push(HEADERS);
                $.each(valuesObj, function(indexArray, value) {
                    var reference = [];
                    reference.push(value.semana);
                    reference.push(value.produccion);
                    reference.push(value.venta);
                    reference.push(value.inversion);
                    reference.push(value.utilidad);
                    VALUES.push(reference)
                });
            }
            // Load chart
            $('#barchart_summary').empty();
            $('#authenticationChart').modal('hide');
            google
                .charts
                .setOnLoadCallback(drawPaymentChart);
        }
        else {
            $('.alert .name-predio').text(Chart.getNamePredio());
            $('#filterDate').attr('disabled', true);
            $('.alert').show();
            $('#barchart_summary').empty();
            $('#barchart_earnings').empty();
            $('#trendline_ratio').empty();
            $('#barchart_sales').empty();
            $('#barchart_investments').empty();
            $('#barchart_materials').empty();
        }
    }

    function drawPaymentChart() {
        var data = google
            .visualization
            .arrayToDataTable(VALUES);

        var tickMarks = [];
        //add first
        tickMarks.push(data.getValue(0, 0));
        //add last
        tickMarks.push(data.getValue(data.getNumberOfRows() - 1, 0));

        var options = Chart.getOptionsChart();
        options.seriesType = 'bars';
        options.series= {5: {type: 'line'}};
        options.title = 'Reporte General Utilidades',
        options.colors = ['#210f2b', '#428bca', '#d95f02', '#1b9e77'];
        options.hAxis = {
            format: '',
            title: Chart.getTitleAxis(),
            ticks: tickMarks
        };
        
        var chart = new google.visualization.ComboChart(document.getElementById('barchart_earnings'));
        chart.draw(data, options);
    }

    return self;
})(jQuery);

window.Chart.Ratio = (function($) {
    var HEADERS = ['Semana', 'Produccion', { role: 'annotation' }];
    var VALUES = [];

    self.loadRatio = function(predio_id, type) {
        ratios(predio_id, type);
        Chart.Investment.loadInvestment(predio_id, type)
    };

    function ratios(predio_id, type) {
        var settings = {
            type: "GET",
            url: '/predios/' + predio_id + '/ratio' + type,
            dataType: "json",
            error: Chart.onError,
            success: onSuccess
        };
        return $.ajax(settings);
    }

    function onSuccess(data) {
        if (!Chart.isEmpty(data)) {
            var valuesObj = Object.values(data);
            var keysObj = Object.keys(data);
            VALUES = [];
            if ($.isArray(valuesObj) && $.isArray(keysObj)) {
                VALUES.push(HEADERS);
                $.each(valuesObj, function(index, value) {
                    var reference = [];
                    reference.push(keysObj[index]);
                    reference.push(Number(value));
                    reference.push(Number(value));
                    VALUES.push(reference)
                });
            }
            // Load chart
            google
                .charts
                .setOnLoadCallback(drawRatioChart);
        }
    }

    function drawRatioChart() {
        var data = google.visualization.arrayToDataTable(VALUES);

        var options = {
            title: 'Produccion',
            colors: ['#210f2b'],
            vAxis: {
                title: 'Produccion'
            },
            hAxis: {
                title: Chart.getTitleAxis()
            },
            height: 400,
            width: '100%',
            pointShape: 'diamond',
            animation: {
                duration: 1500,
                easing: 'out',
                startup: true
            },
            bar: {
                groupWidth: "95%"
            }
        };

        var chart = new google.visualization.LineChart(document.getElementById('trendline_ratio'));
        chart.draw(data, options);
    }

    return self;
})(jQuery);

window.Chart.Investment = (function($) {
    var HEADERS = ['Semana', 'Gastos', { role: 'annotation' }];
    var VALUES = [];

    self.loadInvestment = function(predio_id, type) {
        investments(predio_id, type);
        Chart.Sales.loadSales(predio_id, type)
    };

    function investments(predio_id, type) {
        var settings = {
            type: "GET",
            url: '/predios/' + predio_id + '/investment' + type,
            dataType: "json",
            error: Chart.onError,
            success: onSuccess
        };
        return $.ajax(settings);
    }

    function onSuccess(data) {
        if (!Chart.isEmpty(data)) {
            var valuesObj = Object.values(data);
            var keysObj = Object.keys(data);
            VALUES = [];
            if ($.isArray(valuesObj) && $.isArray(keysObj)) {
                VALUES.push(HEADERS);
                $.each(valuesObj, function(index, value) {
                    var reference = [];
                    reference.push(keysObj[index]);
                    reference.push(Number(value));
                    reference.push(Number(value));
                    VALUES.push(reference)
                });
            }
            // Load chart
            google
                .charts
                .setOnLoadCallback(drawPaymentChart);
        }
    }

    function drawPaymentChart() {
        var data = google.visualization.arrayToDataTable(VALUES);

        var options = Chart.getOptionsChart();
        options.title = 'Pagos';
        options.colors = ['#d95f02'];
        
        var chart = new google.visualization.ColumnChart(document.getElementById('barchart_investments'));

        chart.draw(data, options);
    }

    return self;
})(jQuery);

window.Chart.Sales = (function($) {
    var HEADERS = ['Semana', 'Ventas',  { role: 'annotation' }];
    var VALUES = [];

    self.loadSales = function(predio_id, type) {
        sales(predio_id, type);
        Chart.Materials.loadMaterials(predio_id, type)
    };

    function sales(predio_id, type) {
        var settings = {
            type: "GET",
            url: '/predios/' + predio_id + '/sales' + type,
            dataType: "json",
            error: Chart.onError,
            success: onSuccess
        };
        return $.ajax(settings);
    }

    function onSuccess(data) {
        if (!Chart.isEmpty(data)) {
            var valuesObj = Object.values(data);
            var keysObj = Object.keys(data);
            VALUES = [];
            if ($.isArray(valuesObj) && $.isArray(keysObj)) {
                VALUES.push(HEADERS);
                $.each(valuesObj, function(index, value) {
                    var reference = [];
                    reference.push(keysObj[index]);
                    reference.push(Number(value));
                    reference.push(Number(value));
                    VALUES.push(reference)
                });
            }
            // Load chart
            google
                .charts
                .setOnLoadCallback(drawPaymentChart);
        }
    }

    function drawPaymentChart() {
        var data = google
            .visualization
            .arrayToDataTable(VALUES);

        var options = Chart.getOptionsChart();
        options.title = 'Ventas';
        options.colors = ['#428bca'];

        var chart = new google.visualization.ColumnChart(document.getElementById('barchart_sales'));
        chart.draw(data, options);
    }

    return self;
})(jQuery);

window.Chart.Materials = (function($) {
    var HEADERS = ['Semana', 'Cantidad',  { role: 'annotation' }];
    var VALUES = [];

    self.loadMaterials = function(predio_id, type) {
        materials(predio_id, type)
    };

    function materials(predio_id, type) {
        var settings = {
            type: "GET",
            url: '/predios/' + predio_id + '/materials' + type,
            dataType: "json",
            error: Chart.onError,
            success: onSuccess
        };
        return $.ajax(settings);
    }

    function onSuccess(data) {
        if (!Chart.isEmpty(data)) {
            var valuesObj = Object.values(data);
            var keysObj = Object.keys(data);
            VALUES = [];
            if ($.isArray(valuesObj) && $.isArray(keysObj)) {
                VALUES.push(HEADERS);
                $.each(valuesObj, function(index, value) {
                    var reference = [];
                    reference.push(keysObj[index]);
                    reference.push(Number(value));
                    reference.push(Number(value));
                    VALUES.push(reference)
                });
            }
            // Load chart
            google
                .charts
                .setOnLoadCallback(drawPaymentChart);
        }
    }

    function drawPaymentChart() {
        var data = google
            .visualization
            .arrayToDataTable(VALUES);

        var options = Chart.getOptionsChart();
        options.title = 'Materiales';
        options.colors = ['gold'];

        var chart = new google.visualization.ColumnChart(document.getElementById('barchart_materials'));
        chart.draw(data, options);
    }

    return self;
})(jQuery);