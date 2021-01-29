model = Model(Ipopt.Optimizer)

a = 1.0
b = 3.0
L = 3.0
n = 51 #número de divisões de intervalo
h = L/(n-1)

@variable(model, x[1:n])
@variable(model, u[1:n])

for i = 2:n
    @NLobjective(model, Min, h*((x[i]*sqrt(1 + u[i]^2) + x[i-1]*sqrt(1 + u[i-1]^2)/2)))
    @NLconstraint(model, 0.5*h*(sqrt(1 + u[i]) + sqrt(1 + u[i-1])) == L)
    @constraint(model, x[i] - x[i-1] == h*(u[i-1] + u[i])/2)
end

@constraint(model, x[1] == a)
@constraint(model, x[n] == b)

optimize!(model)

gr(size=(400,600))
plot(range(0, 1, length=n), x, m = (3,:blue), leg = false)
