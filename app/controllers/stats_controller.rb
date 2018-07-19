class StatsController < ApplicationController
  def new_users
    render json: User.group_by_day(:created_at).count
  end

  def investment
    @predio_id = params[:predio_id]
    query = "SELECT SUM(amount) as Inversion, semana as semana
              FROM (select   sum(materials.price * ipd.cantidad) as amount, info_predios.semana
              from info_predio_detalles as ipd  
              LEFT JOIN  info_predios ON  ipd.info_predio_id = info_predios.id
              Left JOIN materials  ON materials.id = ipd.material_id
              where  info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              Group by info_predios.semana
              UNION select  sum(otros_gastos.precio) as amount , info_predios.semana
              from otros_gastos 
              LEFT JOIN  info_predios ON  otros_gastos.info_predio_id = info_predios.id
              where info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              Group by info_predios.semana
              UNION  select   sum(fumigada + pago_trabaja + nutriente ) as amount, semana
              from info_predios 
              where info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              Group by info_predios.semana) 
              Group by semana"

    @inversion = ActiveRecord::Base.connection.execute(sprintf(query, @predio_id,  @predio_id,  @predio_id))
    my_array = Hash.new
    unless @inversion.nil?
      Array(@inversion).each do |data|
         my_array[data["semana"]] = data["Inversion"]
      end
    end
    render json: my_array
  end

  def investmentByMonth
    @predio_id = params[:predio_id]
    
    query = "SELECT SUM(amount) as Inversion, mes
              FROM ( SELECT sum(materials.price * ipd.cantidad) as amount, strftime('%%m', info_predios.created_at)  AS mes
              from info_predio_detalles as ipd  
              LEFT JOIN  info_predios ON  ipd.info_predio_id = info_predios.id
              Left JOIN materials  ON materials.id = ipd.material_id
              where  info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              Group by mes
              UNION SELECT  sum(otros_gastos.precio) as amount , strftime('%%m', info_predios.created_at)  AS mes
              from otros_gastos 
              LEFT JOIN  info_predios ON  otros_gastos.info_predio_id = info_predios.id
              where info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
	            Group by mes
              UNION  SELECT   sum(fumigada + pago_trabaja + nutriente ) as amount, strftime('%%m', info_predios.created_at)  AS mes
              from info_predios 
              where info_predios.predio_id = %d
	            Group by mes)
              Group by mes"

    @inversion = ActiveRecord::Base.connection.execute(sprintf(query, @predio_id,  @predio_id,  @predio_id))
    my_array = Hash.new
    unless @inversion.nil?
      Array(@inversion).each do |data|
          case data["mes"]
          when "01"
          @mes = 'Enero'
          when "02"
          @mes = 'Febrero'
          when '03'
          @mes = 'Marzo'
          when '04'
          @mes = 'Abril'
          when '05'
          @mes = 'Mayo'
          when '06'
          @mes = 'Junio'
          when '07'
          @mes = 'Julio'
          when '08'
          @mes = 'Agosto'
          when '09'
          @mes = 'Septiemmbre'
          when '10'
          @mes = 'Octubre'
          when '11'
          @mes = 'Noviembre'
          when '12'
          @mes = 'Diciembre'
          end
          
          my_array[@mes] = data["Inversion"]
      end
    end
    render json: my_array
  end

  def sales
    @predio_id = params[:predio_id]
    query = "select venta, semana
              from info_predios 
              where info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              GROUP BY semana"

    @sales = ActiveRecord::Base.connection.execute(sprintf(query, @predio_id))
    my_array = Hash.new
    unless @sales.nil?
      Array(@sales).each do |data|
          my_array[data["semana"]] = data["venta"]
      end
    end
    render json: my_array
  end

  def salesByMonth
    @predio_id = params[:predio_id]
    query = "select SUM(venta) as venta, strftime('%%m', info_predios.created_at)  AS mes
              from info_predios 
              where info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              GROUP BY mes"

    @sales = ActiveRecord::Base.connection.execute(sprintf(query, @predio_id))
    my_array = Hash.new
    unless @sales.nil?
      Array(@sales).each do |data|
          case data["mes"]
          when "01"
          @mes = 'Enero'
          when "02"
          @mes = 'Febrero'
          when '03'
          @mes = 'Marzo'
          when '04'
          @mes = 'Abril'
          when '05'
          @mes = 'Mayo'
          when '06'
          @mes = 'Junio'
          when '07'
          @mes = 'Julio'
          when '08'
          @mes = 'Agosto'
          when '09'
          @mes = 'Septiemmbre'
          when '10'
          @mes = 'Octubre'
          when '11'
          @mes = 'Noviembre'
          when '12'
          @mes = 'Diciembre'
          end
          
          my_array[@mes] = data["venta"]
      end
    end
    render json: my_array
  end

  def earnings
    @predio_id = params[:predio_id]
    #SALES
    query = "select conteo_racimos * precio as venta, semana
              from info_predios 
              where info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              GROUP BY semana"
    @sales = ActiveRecord::Base.connection.execute(sprintf(query, @predio_id))
    #INVESTMENT
    query = "SELECT SUM(amount) as Inversion, semana as semana
              FROM (select   sum(materials.price * ipd.cantidad) as amount, info_predios.semana
              from info_predio_detalles as ipd  
              LEFT JOIN  info_predios ON  ipd.info_predio_id = info_predios.id
              Left JOIN materials  ON materials.id = ipd.material_id
              where  info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              Group by info_predios.semana
              UNION select  sum(otros_gastos.precio) as amount , info_predios.semana
              from otros_gastos 
              LEFT JOIN  info_predios ON  otros_gastos.info_predio_id = info_predios.id
              where info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              Group by info_predios.semana
              UNION  select   sum(fumigada + pago_trabaja + nutriente ) as amount, semana
              from info_predios 
              where info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              Group by info_predios.semana
              )Group by semana"

    @inversion = ActiveRecord::Base.connection.execute(sprintf(query, @predio_id,  @predio_id,  @predio_id))
    
    my_array = Hash.new
    unless @sales.nil?
      Array(@sales).each_with_index {|data, index|
          semanaArray = Hash.new
          semanaArray['semana'] = data["semana"]
          semanaArray['venta'] = data["venta"]
          semanaArray['inversion'] = @inversion[index]["Inversion"]
          semanaArray['utilidad'] = data["venta"] - @inversion[index]["Inversion"]
          my_array[index] = semanaArray
        }
    end
    
    render json: my_array
  end

  def earningsByMonth
    @predio_id = params[:predio_id]
    #SALES
    query = "select SUM(venta) as venta, strftime('%%m', info_predios.created_at)  AS mes
              from info_predios 
              where info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              GROUP BY mes"
    @sales = ActiveRecord::Base.connection.execute(sprintf(query, @predio_id))
    #INVESTMENT
    query = "SELECT SUM(amount) as Inversion, mes
              FROM ( SELECT sum(materials.price * ipd.cantidad) as amount, strftime('%%m', info_predios.created_at)  AS mes
              from info_predio_detalles as ipd  
              LEFT JOIN  info_predios ON  ipd.info_predio_id = info_predios.id
              Left JOIN materials  ON materials.id = ipd.material_id
              where  info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
              Group by mes
              UNION SELECT  sum(otros_gastos.precio) as amount , strftime('%%m', info_predios.created_at)  AS mes
              from otros_gastos 
              LEFT JOIN  info_predios ON  otros_gastos.info_predio_id = info_predios.id
              where info_predios.predio_id = %d
              and info_predios.created_at >= date('now', 'start of year')
	            Group by mes
              UNION  SELECT   sum(fumigada + pago_trabaja + nutriente ) as amount, strftime('%%m', info_predios.created_at)  AS mes
              from info_predios 
              where info_predios.predio_id = %d
	            Group by mes)
              Group by mes"

    @inversion = ActiveRecord::Base.connection.execute(sprintf(query, @predio_id,  @predio_id,  @predio_id))
    
    my_array = Hash.new
    unless @sales.nil?
      Array(@sales).each_with_index {|data, index|
          semanaArray = Hash.new
          case data["mes"]
          when "01"
          @mes = 'Enero'
          when "02"
          @mes = 'Febrero'
          when '03'
          @mes = 'Marzo'
          when '04'
          @mes = 'Abril'
          when '05'
          @mes = 'Mayo'
          when '06'
          @mes = 'Junio'
          when '07'
          @mes = 'Julio'
          when '08'
          @mes = 'Agosto'
          when '09'
          @mes = 'Septiemmbre'
          when '10'
          @mes = 'Octubre'
          when '11'
          @mes = 'Noviembre'
          when '12'
          @mes = 'Diciembre'
          end
          semanaArray['semana'] = @mes
          semanaArray['venta'] = data["venta"]
          semanaArray['inversion'] = @inversion[index]["Inversion"]
          semanaArray['utilidad'] = data["venta"] - @inversion[index]["Inversion"]
          my_array[index] = semanaArray
        }
    end
    
    render json: my_array
  end

  def materials
    @predio_id = params[:predio_id]
    query = "select  info_predio_detalles.cantidad as cantidad, semana
              from info_predios 
              INNER JOIN info_predio_detalles ON  info_predio_detalles.info_predio_id = info_predios.id
              INNER JOIN materials ON  materials.id = info_predio_detalles.material_id
              where info_predios.predio_id = "+ @predio_id +"
              and materials.name LIKE \"%bolsa%\"
              and info_predios.created_at >= date('now', 'start of year')
              GROUP BY semana"

    @materials = ActiveRecord::Base.connection.execute(query)
    my_array = Hash.new
    unless @materials.nil?
      Array(@materials).each do |data|
          my_array[data["semana"]] = data["cantidad"]
      end
    end
    render json: my_array
  end

  def materialsByMonth
    @predio_id = params[:predio_id]
    query = "select SUM(info_predio_detalles.cantidad) as cantidad, strftime(\"%m\", info_predios.created_at)  AS mes
              from info_predios 
              INNER JOIN info_predio_detalles ON  info_predio_detalles.info_predio_id = info_predios.id
              INNER JOIN materials ON  materials.id = info_predio_detalles.material_id
              where info_predios.predio_id = "+ @predio_id +"
              and materials.name LIKE \"%bolsa%\"
              and info_predios.created_at >= date('now', 'start of year')
              GROUP BY mes"

    @materials = ActiveRecord::Base.connection.execute(query)
    my_array = Hash.new
    unless @materials.nil?
      Array(@materials).each do |data|
         case data["mes"]
          when "01"
          @mes = 'Enero'
          when "02"
          @mes = 'Febrero'
          when '03'
          @mes = 'Marzo'
          when '04'
          @mes = 'Abril'
          when '05'
          @mes = 'Mayo'
          when '06'
          @mes = 'Junio'
          when '07'
          @mes = 'Julio'
          when '08'
          @mes = 'Agosto'
          when '09'
          @mes = 'Septiemmbre'
          when '10'
          @mes = 'Octubre'
          when '11'
          @mes = 'Noviembre'
          when '12'
          @mes = 'Diciembre'
          end
          my_array[@mes] = data["cantidad"]
      end
    end
    render json: my_array
  end

end