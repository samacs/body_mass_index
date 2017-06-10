class BMI
  attr_accessor :weight, :height, :imperial, :bmi

  def initialize(options = {})
    @imperial = options[:imperial] || false

    fail ArgumentError, 'Please enter your weight' if
      options[:weight].nil? || options[:weight].to_f.zero?
    fail ArgumentError, 'Please enter your height' if
      options[:height].nil? || options[:height].to_f.zero?

    @weight = options[:weight].to_f
    @height = options[:height].to_f
  end

  def calculate
    @bmi = if @imperial
             (@weight / (@height * @height)) * 703
           else
             @weight / (@height * @height)
           end
    @bmi = (format '%.1f', @bmi).to_f
  end

  def category
    calculate unless @bmi
    case @bmi
    when (0...15)
      'Very severely underweight'
    when (15...16)
      'Severely underweight'
    when (16...18.5)
      'Underweight'
    when (18.5...25)
      'Normal (healthy weight)'
    when (25...30)
      'Overweight'
    when (30...35)
      'Obese Class I (Moderately obese)'
    when (35...40)
      'Obese Class II (Severely obese)'
    when @bmi > 40
      'Obese Class III (Very severely obese)'
    end
  end
end
