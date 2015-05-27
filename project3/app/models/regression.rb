require 'statsample' # To get linear regression coefficients readily
require 'matrix'

class Regression
	def initialize(xs, ys)
		@xs, @ys = xs, ys
		@n = @xs.length # N number of pairs of (X,Y) points
	end

	def get_linear_coeffs
		regress = Statsample::Regression::Simple.new_from_vectors(@xs.to_scale, @ys.to_scale)

		@linear_coeffs = [regress.a.round(2), regress.b.round(2)]
	end

	# Method taken from Project 1 specifications
	def get_polynomial_coeffs(degree)
		x_data = @xs.map {|x_i| (0..degree).map {|pow| (x_i**pow).to_f}}
		mx = Matrix[*x_data]
		my = Matrix.column_vector(@ys)

		poly_coeffs = ((mx.t * mx).inv * mx.t * my).transpose.to_a[0]
		@polynomial_coeffs = poly_coeffs.map {|elem| elem.round(2)}
	end

	# Applying least squares fitting, guide from http://mathworld.wolfram.com/LeastSquaresFittingLogarithmic.html
	def get_log_coeffs 
		p = (0...@n).reduce(0) {|sum, i| sum + (@ys[i]*Math::log(@xs[i]))} # Sum {y*ln(x)}
		q = (0...@n).reduce(0) {|sum, i| sum + @ys[i]} # Sum {y}
		r = (0...@n).reduce(0) {|sum, i| sum + Math::log(@xs[i])} # Sum {ln(x)}
		s = (0...@n).reduce(0) {|sum, i| sum + (Math::log(@xs[i]))**2} # Sum {ln(x)^2}
		
		b = (@n*p - q*r) / (@n*s - r**2)
		a = (q - b*r) / @n

		@log_coeffs = [a.round(2), b.round(2)]
	end

	# Applying least squares fitting, guide from http://mathworld.wolfram.com/LeastSquaresFittingExponential.html
	def get_exp_coeffs 
		p = (0...@n).reduce(0) {|sum, i| sum + Math::log(@ys[i])} # Sum {ln(y)}
		q = (0...@n).reduce(0) {|sum, i| sum + (@xs[i]**2)} # Sum {x^2}
		r = (0...@n).reduce(0) {|sum, i| sum + @xs[i]}	# Sum {x}
		s = (0...@n).reduce(0) {|sum, i| sum + (@xs[i]*Math::log(@ys[i]))} # Sum {x*ln(y)}

		a = (p*q - r*s) / (@n*q - r**2)
		b = (@n*s - r*p) / (@n*q - r**2)

		@exp_coeffs = [Math::exp(a).round(2), b.round(2)]
	end

	# Compare errors of each polynomial regression from degree 2 to 10 and return the degree that leads to the smallest error
	def best_degree
		errors = []

		(2..10).to_a.each do |degree|
			errors[degree-2] = standard_error('polynomial', degree) 
		end

		errors.index(errors.min) + 2 # Since indexes start with 0
	end

	# Measure of the accuracy of predictions made with a regression
	def standard_error(type, degree = best_degree)
		begin
			y_regressed = get_y_regressed(type, degree)

			sse = (0...@n).reduce(0) {|sum, i| sum + ((@ys[i] - y_regressed[i])**2)} # Sum of square error
			return Math::sqrt(sse / @n)

		rescue Math::DomainError 	# If the regression cannot be performed,
			return Float::INFINITY 	# the error will be infinite so it can be compared with other regressions errors
		end
	end

	def get_R2(type, degree = best_degree)
		begin
			y_regressed = get_y_regressed(type, degree)

			d =	(0...@n).inject(0){|sum, i| sum + (@ys[i]*y_regressed[i])}
			sum_ys = (0...@n).inject(0){|sum, i| sum + @ys[i]}
			sum_y_regressed = (0...@n).inject(0){|sum, i| sum + y_regressed[i]}
			e = (0...@n).inject(0){|sum, i| sum + @ys[i]**2}
			f = (0...@n).inject(0){|sum, i| sum + y_regressed[i]**2}

			r = (@n*d - sum_ys*sum_y_regressed)/(Math.sqrt(((@n*e-sum_ys**2)*(@n*f-sum_y_regressed**2))))
			r_2 = r**2

			@probability = r_2
			
			return r_2 

		rescue Math::DomainError 	
			return 0 	
		end
	end

	def get_y_regressed (type, degree = best_degree)
		y_regressed = [] # Will contain the calculated ys from a regressed equation
		
		case type
		when 'linear'
			get_linear_coeffs
			(0...@n).to_a.each {|i| y_regressed[i] = @linear_coeffs[1]*@xs[i] + @linear_coeffs[0]}

		when "polynomial"
			get_polynomial_coeffs(degree)
			(0...@n).to_a.each do |i|
				y_regressed[i] = (0..degree).reduce(0) {|sum, j| sum + (@polynomial_coeffs[j]*(@xs[i]**j))}
			end

		when "exponential"
			get_exp_coeffs
			(0...@n).to_a.each {|i| y_regressed[i] = @exp_coeffs[0]*(Math::E**(@exp_coeffs[1]*@xs[i]))}

		when "logarithmic"
			get_log_coeffs
			(0...@n).to_a.each {|i| y_regressed[i] = @log_coeffs[0] + (@log_coeffs[1]*Math::log(@xs[i]))}
		end

		return y_regressed
	end
	
	# Compute the coefficients for a type of regression and print the respective equation
	def evaluate(type)
		info = Hash.new

		begin
			case type
			when 'linear'
				info[:coeffs] = get_linear_coeffs

			when 'polynomial'
				info[:coeffs] = get_polynomial_coeffs(best_degree)
					
			when 'exponential'
				info[:coeffs] = get_exp_coeffs
				
			when 'logarithmic'
				info[:coeffs] = get_log_coeffs	

			when 'best_fit' # chooses the regression with the smallest error
				errors = Hash.new

				['linear', 'polynomial', 'logarithmic', 'exponential'].each do |kind|
					errors[kind] = standard_error(kind)
				end

				return evaluate(errors.key(errors.values.min))
			end	

			info[:type] = type
			info[:probability] = get_R2(type).round(4)
			return info

		rescue Math::DomainError
			puts "Cannot perform #{type} regression on this data"
		end
	end

	def best_fit(data)
		@xs = [*1..data.length]
		@ys = data
		@n = data.length

		return evaluate(best_fit)
	end
end 
