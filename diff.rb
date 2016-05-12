require 'mathn.rb'

#сама функция f(x)
def f(x)
	x**2 - Math::log10(x + 2)
end

#производная f(x)
def df(x)
	2*x - 1/(x + 2)/Math::log(10)
end

#4-я производная f(x)
def df4(x)
	6/(x + 2)**4/Math::log(10)
end

#Факториал
def fact(n)
	if (n == 0)
		return 1
	end
	fact(n - 1) * n
end

class Array
	#Cумма
	def sum()
		a = 0
		for i in (0...self.length)
			a += self[i]
		end
		a
	end

	#Произведение
	def pr()
		a = 1
		for i in (0...self.length)
			a *= self[i]
		end
		a
	end
end

$a = 0.5
$b = 1.0
$h = ($b - $a)/10

#Табличные значения
$xi = Array.new(11){|i| $a + $h * i}
$fi = Array.new(11){|i| f($xi[i])}

#Омега (x - x_i)*(x - x_j)
def omega(x, i0, i, j)
	(x - $xi[i0 + i])*(x - $xi[i0 + j])
end

#Омега n (x - x_0)...(x - x_{n-1})
def domega_n(x, n, i0)
	Array.new(4) do |i| 
		k = (0..3).to_a.select{|j| j != i}.map{|j| x - $xi[i0 + j]}.pr
	end.sum
end

#Производная функции Лагранжа 3-й степени
def dlagrange(x, i0)
	c = [-1/6, 1/2, -1/2, 1/6]
	r = 0;
	for i in (0..3)
		for j in (0...i)
			t = (0..3).to_a.select{|k| k != i and k != j}
			r += (c[i]*$fi[i0 + i] + c[j]*$fi[i0 + j])*omega(x, i0, t[0], t[1])
		end
	end
	r /$h**3
end

#Погрешность
def r(f4, x, i0)
	(f4 * domega_n(x, 4, i0)/fact(4)).abs
end


t = $xi[2]
puts "Ln(x_m) = #{dlagrange(t, 0)}"
puts "f'(x_m) = #{df(t)}"
puts "R_4(x_m) = #{(dlagrange(t, 0) - df(t)).abs}"
puts "R_4_min(x_m) = #{r(df4($xi[0]), t, 0)}"
puts "R_4_max(x_m) = #{r(df4($xi[3]), t, 0)}"
