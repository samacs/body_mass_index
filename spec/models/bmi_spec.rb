describe BMI, type: :model do
  it 'should fail when no height is provided' do
    options = { weight: 60 }
    expect { BMI.new(options).calculate }.to raise_error(ArgumentError)
  end

  it 'should fail when no weight is provided' do
    options = { height: 1.80 }
    expect { BMI.new(options).calculate }.to raise_error(ArgumentError)
  end

  it 'should calculate BMI in metric units by default' do
    expected = [{ weight: 60, height: 1.80, bmi: 18.5 },
                { weight: 100, height: 1.80, bmi: 30.9 }]

    expected.each do |options|
      expect(BMI.new(options).calculate).to eq(options[:bmi])
    end
  end

  it 'should calculate BMI in imperial units' do
    expected = [{ weight: 132.277, height: 70.8661, bmi: 18.5, imperial: true },
                { weight: 220.462, height: 70.8661, bmi: 30.9, imperial: true }]

    expected.each do |options|
      expect(BMI.new(options).calculate).to eq(options[:bmi])
    end
  end

  it 'should calculate the right category from metric units depending on BMI' do
    expected = [{ weight: 60, height: 1.80, bmi: 18.5, category: 'Normal (healthy weight)' },
                { weight: 100, height: 1.80, bmi: 30.9, category: 'Obese Class I (Moderately obese)' }]

    expected.each do |options|
      bmi = BMI.new(options)
      expect(bmi.calculate).to eq(options[:bmi])
      expect(bmi.category).to eq(options[:category])
    end
  end

  it 'should calculate the right category from imperial units depending on BMI' do
    expected = [{ weight: 132.277, height: 70.8661, bmi: 18.5, imperial: true, category: 'Normal (healthy weight)' },
                { weight: 220.462, height: 70.8661, bmi: 30.9, imperial: true, category: 'Obese Class I (Moderately obese)' }]

    expected.each do |options|
      bmi = BMI.new(options)
      expect(bmi.calculate).to eq(options[:bmi])
      expect(bmi.category).to eq(options[:category])
    end
  end

  it 'should fail if height is zero' do
    options = { weight: 60, height: 0 }
    expect { BMI.new(options) }.to raise_error(ArgumentError)
  end

  it 'should fail if weight is zero' do
    options = { weight: 0, height: 1.80 }
    expect { BMI.new(options).to raise_error(ArgumentError) }
  end
end
