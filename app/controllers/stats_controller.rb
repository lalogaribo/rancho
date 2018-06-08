class StatsController < ApplicationController
  def new_users
    render json: User.group_by_day(:created_at).count
  end

  def payments
    @predio_id = params[:predio_id]
    query = "SELECT SUM(amount) as Inversion, semana as semana
              FROM (select   sum(materials.price * ipd.cantidad) as amount, info_predios.semana
              from info_predio_detalles as ipd  
              LEFT JOIN  info_predios ON  ipd.info_predio_id = info_predios.id
              Left JOIN materials  ON materials.id = ipd.material_id
              where  info_predios.predio_id = %d
              Group by info_predios.semana
              UNION select  sum(otros_gastos.precio) as amount , info_predios.semana
              from otros_gastos 
              LEFT JOIN  info_predios ON  otros_gastos.info_predio_id = info_predios.id
              where info_predios.predio_id = %d
              Group by info_predios.semana
              UNION  select   sum(fumigada + pago_trabaja + nutriente ) as amount, semana
              from info_predios 
              where info_predios.predio_id = %d
              Group by info_predios.semana
              )Group by semana"

    @inversion = ActiveRecord::Base.connection.execute(sprintf(query, @predio_id,  @predio_id,  @predio_id))
    my_array = Hash.new
    unless @inversion.nil?
      Array(@inversion).each do |data|
         my_array[data["semana"]] = data["Inversion"]
      end
    end
    render json: my_array
  end

  def sales
    @predio_id = params[:predio_id]
    query = "select conteo_racimos * precio as venta, semana
              from info_predios 
              where info_predios.predio_id = %d
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

  def earnings
    @predio_id = params[:predio_id]
    #SALES
    query = "select conteo_racimos * precio as venta, semana
              from info_predios 
              where info_predios.predio_id = %d
              GROUP BY semana"
    @sales = ActiveRecord::Base.connection.execute(sprintf(query, @predio_id))
    #PAYMENTS
    query = "SELECT SUM(amount) as Inversion, semana as semana
              FROM (select   sum(materials.price * ipd.cantidad) as amount, info_predios.semana
              from info_predio_detalles as ipd  
              LEFT JOIN  info_predios ON  ipd.info_predio_id = info_predios.id
              Left JOIN materials  ON materials.id = ipd.material_id
              where  info_predios.predio_id = %d
              Group by info_predios.semana
              UNION select  sum(otros_gastos.precio) as amount , info_predios.semana
              from otros_gastos 
              LEFT JOIN  info_predios ON  otros_gastos.info_predio_id = info_predios.id
              where info_predios.predio_id = %d
              Group by info_predios.semana
              UNION  select   sum(fumigada + pago_trabaja + nutriente ) as amount, semana
              from info_predios 
              where info_predios.predio_id = %d
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


  def materials
    @predio_id = params[:predio_id]
    query = "select  info_predio_detalles.cantidad as cantidad, semana
              from info_predios 
              INNER JOIN info_predio_detalles ON  info_predio_detalles.info_predio_id = info_predios.id
              INNER JOIN materials ON  materials.id = info_predio_detalles.material_id
              where info_predios.predio_id = "+ @predio_id +"
              and materials.name LIKE \"%bolsa%\"
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
end