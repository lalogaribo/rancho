window.Chart = (function($) {
    var PREDIO_ID = undefined;

    // Initialize
    self.init = function() {
        $(document).ready(function() {
            google.charts.load('current', {
                'packages': ['bar']
            });

            if (predioExist()) {
                Chart.Earnings.loadEarnings(PREDIO_ID, '')
                $('#filterDate').attr('disabled', false);
            }
            else{
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
            $('#predio').val(PREDIO_ID)
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
            }
            else if(typeFilter == '2'){
                type = '/month'
            }
            else {
                type = '/year'
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

    // Initialize
    self.init();

    return self;

})(jQuery);

window.Chart.Earnings = (function($) {
    var HEADERS = ['Semana', 'Ventas', 'Inversion', 'Utilidad'];
    var VALUES = [];

    self.loadEarnings = function(predio_id, type) {
        sales(predio_id, type)
        Chart.Payments.loadPayments(predio_id, type)
    };

    function sales(predio_id, type) {
        var settings = {
            type: "GET",
            url : '/predios/' + predio_id + '/earnings' + type,
            dataType: "json",
            error: onError,
            success: onSuccess
        };
        return $.ajax(settings);
    }

    function onSuccess(data) {
        var valuesObj = Object.values(data);
        console.log(valuesObj)
        var keysObj = Object.keys(data)
        VALUES = [];
        if ($.isArray(valuesObj) && $.isArray(keysObj)) {
            VALUES.push(HEADERS)
            $.each(valuesObj, function(indexArray, value) {
                var reference = [];
                reference.push(value.semana);
                reference.push(value.venta);
                reference.push(value.inversion);
                reference.push(value.utilidad);
                VALUES.push(reference)
            });
            console.log(VALUES)
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

        var options = {
            chart: {
                title: 'Reporte General',
                subtitle: 'Utilidades',
            },
            bars: 'vertical', // Required for Material Bar Charts.
            vAxis: {
                format: 'currency'
            },
            height: 400,
            chartArea: {
                left: 20,
                top: 0,
                width: '50%',
                height: '75%'
            },
            colors: ['#428bca', '#d95f02', '#1b9e77']
        };

        var chart = new google.charts.Bar(document.getElementById('barchart_earnings'));

        chart.draw(data, google.charts.Bar.convertOptions(options));
    }

    /**
     *
     * @param {Object} xhr
     * @param {String} status
     * @param {String} errorThrown
     */
    function onError(xhr, status, errorThrown) {
        var errorMessage = errorThrown;
        if (typeof xhr.responseJSON === "object" && xhr.responseJSON.hasOwnProperty("error")) {
            errorMessage = xhr.responseJSON.error;
        }
        console.log(errorMessage);
    }

    return self;
})(jQuery);

window.Chart.Payments = (function($) {
    var HEADERS = ['Semana', 'Inversion'];
    var VALUES = [];

    self.loadPayments = function(predio_id, type) {
        payments(predio_id, type)
        console.log('investment')
        Chart.Sales.loadSales(predio_id, type)
    };

    function payments(predio_id, type) {
        var settings = {
            type: "GET",
            url: '/predios/' + predio_id + '/investment' + type,
            dataType: "json",
            error: onError,
            success: onSuccess
        };
        return $.ajax(settings);
    }

    function onSuccess(data) {
        var valuesObj = Object.values(data);
        var keysObj = Object.keys(data)
        VALUES = [];
        if ($.isArray(valuesObj) && $.isArray(keysObj)) {
            VALUES.push(HEADERS)
            $.each(valuesObj, function(index, value) {
                var reference = [];
                reference.push(keysObj[index]);
                reference.push(value);
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

        var options = {
            chart: {
                title: 'Inversion',
                subtitle: 'Inversion por semana',
            },
            bars: 'vertical', // Required for Material Bar Charts.
            vAxis: {
                format: 'currency'
            },
            height: 400,
            chartArea: {
                left: 20,
                top: 0,
                width: '50%',
                height: '75%'
            },
            colors: ['#d95f02']
        };

        var chart = new google.charts.Bar(document.getElementById('barchart_payments'));

        chart.draw(data, google.charts.Bar.convertOptions(options));
    }

    /**
     *
     * @param {Object} xhr
     * @param {String} status
     * @param {String} errorThrown
     */
    function onError(xhr, status, errorThrown) {
        var errorMessage = errorThrown;
        if (typeof xhr.responseJSON === "object" && xhr.responseJSON.hasOwnProperty("error")) {
            errorMessage = xhr.responseJSON.error;
        }
        console.log(errorMessage);
    }

    return self;
})(jQuery);

window.Chart.Sales = (function($) {
    var HEADERS = ['Semana', 'Ventas'];
    var VALUES = [];

    self.loadSales = function (predio_id, type) {
        sales(predio_id, type)
        Chart.Materials.loadMaterials(predio_id, type)
    };

    function sales(predio_id, type) {
        var settings = {
            type: "GET",
            url: '/predios/' + predio_id + '/sales' + type,
            dataType: "json",
            error: onError,
            success: onSuccess
        };
        return $.ajax(settings);
    }

    function onSuccess(data) {
        var valuesObj = Object.values(data);
        var keysObj = Object.keys(data)
        VALUES = [];
        if ($.isArray(valuesObj) && $.isArray(keysObj)) {
            VALUES.push(HEADERS)
            $.each(valuesObj, function(index, value) {
                var reference = [];
                reference.push(keysObj[index]);
                reference.push(value);
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

        var options = {
            chart: {
                title: 'Ventas',
                subtitle: 'Ventas por semana',
            },
            bars: 'vertical', // Required for Material Bar Charts.
            vAxis: {
                format: 'currency'
            },
            height: 400,
            chartArea: {
                left: 20,
                top: 0,
                width: '50%',
                height: '75%'
            },
            colors: ['#428bca']
        };

        var chart = new google.charts.Bar(document.getElementById('barchart_sales'));

        chart.draw(data, google.charts.Bar.convertOptions(options));
    }

    /**
     *
     * @param {Object} xhr
     * @param {String} status
     * @param {String} errorThrown
     */
    function onError(xhr, status, errorThrown) {
        var errorMessage = errorThrown;
        if (typeof xhr.responseJSON === "object" && xhr.responseJSON.hasOwnProperty("error")) {
            errorMessage = xhr.responseJSON.error;
        }
        console.log(errorMessage);
    }

    return self;
})(jQuery);

window.Chart.Materials = (function($) {
    var HEADERS = ['Semana', 'Cantidad'];
    var VALUES = [];

    self.loadMaterials = function (predio_id, type) {
        materials(predio_id, type)
    };

    function materials(predio_id, type) {
        var settings = {
            type: "GET",
            url: '/predios/' + predio_id + '/materials' + type,
            dataType: "json",
            error: onError,
            success: onSuccess
        };
        return $.ajax(settings);
    }

    function onSuccess(data) {
        var valuesObj = Object.values(data);
        var keysObj = Object.keys(data)
        VALUES = [];
        if ($.isArray(valuesObj) && $.isArray(keysObj)) {
            VALUES.push(HEADERS)
            $.each(valuesObj, function(index, value) {
                var reference = [];
                reference.push(keysObj[index]);
                reference.push(value);
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

        var options = {
            chart: {
                title: 'Materiales',
                subtitle: 'Bolsas por semana',
            },
            bars: 'vertical', // Required for Material Bar Charts.
            vAxis: {
                format: 'decimal'
            },
            height: 400,
            chartArea: {
                left: 20,
                top: 0,
                width: '50%',
                height: '75%'
            },
            colors: ['gold']
        };

        var chart = new google.charts.Bar(document.getElementById('barchart_materials'));

        chart.draw(data, google.charts.Bar.convertOptions(options));
    }

    /**
     *
     * @param {Object} xhr
     * @param {String} status
     * @param {String} errorThrown
     */
    function onError(xhr, status, errorThrown) {
        var errorMessage = errorThrown;
        if (typeof xhr.responseJSON === "object" && xhr.responseJSON.hasOwnProperty("error")) {
            errorMessage = xhr.responseJSON.error;
        }
        console.log(errorMessage);
    }

    return self;
})(jQuery);