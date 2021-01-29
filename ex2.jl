using JuMP, Ipopt, Plots
model = Model(Ipopt.Optimizer)

a = 1.0
b = 3.0
L = 3.0
n = 51 #Divisões do intervalo
h = L/(n-1)

@variable(model, x[1:n])
@variable(model, u[1:n])

for i = 2:n
    @NLobjective(model, Min, (h/2) * (x[i]*sqrt(1 + u[i]^2) + x[i-1]*sqrt(1 + u[i-1]^2))
    @NLconstraint(model, (h/2) * (sqrt(1 + u[i]^2) + sqrt(1 + u[i-1]^2)) == L)
    @constraint(model, x[i] - x[i-1] == h/2 * (u[i-1] + u[i])
end

@constraint(model, x[1] == a)
@constraint(model, x[n] == b)

optimize!(model)

gr(size=(400,600))
plot(range(0, 1, length=n), x, m = (3,:blue), leg = false)
