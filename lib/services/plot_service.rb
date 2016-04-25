class PlotService
  def initialize(plot_type, input_file, output_file)
    @plot_type = plot_type
    @input_file = input_file
    @output_file = output_file
  end

  def call
    `Rscript #{APP_PATH}/lib/plots/#{@plot_type}.R #{APP_PATH}/#{@input_file} #{APP_PATH}/#{@output_file}`
  end

  def self.create_plot_file(data)
    file_name = './tmp/tmp.csv'
    CSV.open(file_name, 'w') do |csv|
      csv << ['VALUES']
      data.each do |row|
        csv << [row]
      end
    end
    file_name
  end
end
