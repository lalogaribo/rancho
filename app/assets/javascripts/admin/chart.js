window.Chart = (function($) {
    var PREDIO_ID = undefined;
    var TITLE_AXIS = 'Semana';

    // Initialize
    self.init = function() {
        $(document).ready(function() {
            google.charts.load('current', {
                'packages': ['corechart' ,'bar']
            });

            if (predioExist()) {
                Chart.Earnings.loadEarnings(PREDIO_ID, '');
                $('#filterDate').attr('disabled', false);
            } else {
                $('#filterDate').attr('disabled', true);
            }

            $(document).on('change', '#predio', function() {
                fetchStatsPredio($(this));
            });

            $(document).on('change', '#filterDate', function() {
                fetchStatsPredioByDate($(this));
            });
        });
    };

    function predioExist() {
        PREDIO_ID = $('#hdPredioId').val();
        if ($.isNumeric(PREDIO_ID)) {
            $('#predio').val(PREDIO_ID);
            return true;
        } else {
            return false;
        }
    }

    function fetchStatsPredioByDate(trigger) {
        var typeFilter = trigger.find(':selected').val();
        if ($.isNumeric(PREDIO_ID)) {
            var type;
            if (typeFilter == '1') {
                type = ''
                TITLE_AXIS = 'Semana';
            } else if (typeFilter == '2') {
                type = '/month'
                TITLE_AXIS = 'Mes';
            } else {
                type = '/year'
                TITLE_AXIS = 'Año';
            }
            Chart.Earnings.loadEarnings(PREDIO_ID, type)
        }
    }

    function fetchStatsPredio(trigger) {
        PREDIO_ID = trigger.find(':selected').val();
        if ($.isNumeric(PREDIO_ID)) {
            $('#filterDate').attr('disabled', false);
            var name = trigger.find(':selected').text();
            $('.namePredio').text(name);
            Chart.Earnings.loadEarnings(PREDIO_ID, '')
        }
    }

    self.getTitleAxis = function() {
        return TITLE_AXIS;
    }

    self.getOptionsChart =function() {
        var options = {
            vAxis: {
                format: 'currency'
            },
            hAxis: {
                format: '',
                title: Chart.getTitleAxis()
            },
            height: 400,
            animation: {
                duration: 1500,
                easing: 'out',
                startup: true
            },
            bar: { groupWidth: '93%' },
            chartArea: {
                width: '80%'
            }
        };

        return options;
    }

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
    }

    // Initialize
    self.init();

    return self;

})(jQuery);

window.Chart.Earnings = (function($) {
    var HEADERS = ['Semana','Produccion', 'Ventas', 'Inversion', 'Utilidad'];
    var VALUES = [];

    self.loadEarnings = function(predio_id, type) {
        earnings(predio_id, type);
        Chart.Ratio.loadRatio(predio_id, type)
    };

    function earnings(predio_id, type) {
        var settings = {
            type: "GET",
            url: '/predios/' + predio_id + '/earnings' + type,
            dataType: "json",
            error: Chart.onError,
            success: onSuccess
        };
        return $.ajax(settings);
    }

    function onSuccess(data) {
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
        google
            .charts
            .setOnLoadCallback(drawPaymentChart);
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
    var HEADERS = ['Semana', 'Inversion', { role: 'annotation' }];
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