using CSV, DataFrames, StatsBase, CairoMakie

Adv23 = CSV.read("AdvStats23.csv", DataFrame, normalizenames=true)
println(names(Adv23)) 
#Selecting and renaming colums not really necessary 
OffAdv23 = select(Adv23, :team => :Team, :conference => :Conference, :off_plays => :OffPlays, :off_pts_per_opp => :OffPointsPerOpp, 
:off_ppa => :OffPPA, :off_success_rate => :OffSucces, :off_explosiveness => :OffExplosive, :off_power_success => :OffPower,
:off_stuff_rate => :OffStuff, :off_line_yds => :OffLineYards, :off_second_lvl_yds => :OffSecondLvl, :off_open_field_yds => :OffOpenField,
:off_havoc_total => :OffHavoc, :off_havoc_front_seven => :OffHavocFront, :off_havoc_db => :OffHavocDB, :off_standard_downs_rate => :OffStandardDownPer,
:off_standard_downs_ppa => :OffStandardDownPPA, :off_standard_downs_success_rate => :OffStandardSuccess, :off_standard_downs_explosiveness => :OffStandardExpl,
:off_passing_downs_rate => :OffPassDownPer, :off_passing_downs_ppa => :OffPassDownPPA, :off_passing_downs_success_rate => :OffPassDownSuccess,
:off_passing_downs_explosiveness => :OffPassDownExpl,
)

AdvDef23 = select(Adv23, :team => :Team, :conference => :Conference, :def_plays => :DefPlays, :def_pts_per_opp => :DefPointsPerOpp,
:def_ppa => :DefPPA, :def_success_rate => :DefSucess, :def_explosiveness => :DefExplosive
)
#Sorting by points per opprtunity for plotting
sort!(OffAdv23, :OffPointsPerOpp, rev=true)
sort!(AdvDef23, :DefPointsPerOpp)
#functions for normalizing data
DivByMean =  (x -> x ./ mean(x))
DivMeanBy = (x -> mean(x) ./ x)
#Spliiting data into gruops
Adv23General = select(OffAdv23, :Team, :OffPPA => DivByMean, :OffSucces => DivByMean, :OffExplosive => DivByMean, renamecols=false)
Adv23General = Adv23General[1:20, :]

Adv23OffLine = select(OffAdv23, :Team, :OffPower => DivByMean, :OffStuff => DivMeanBy, :OffLineYards =>  DivByMean, renamecols=false)
Adv23OffLine = Adv23OffLine[1:20, :]

Adv23OffOpenField = select(OffAdv23, :Team, :OffSecondLvl => DivByMean, :OffOpenField => DivByMean, renamecols=false)
Adv23OffOpenField = Adv23OffOpenField[1:20, :]

Adv23OffHavoc = select(OffAdv23, :Team, :OffHavoc => DivByMean, :OffHavocFront => DivByMean, :OffHavocDB => DivByMean, renamecols=false)
Adv23OffHavoc = Adv23OffHavoc[1:20, :]

Adv23OffStandard = select(OffAdv23, :Team, :OffStandardDownPer => DivByMean, :OffStandardDownPPA => DivByMean, 
:OffStandardSuccess => DivByMean, :OffStandardExpl => DivByMean, renamecols=false)
Adv23OffStandard = Adv23OffStandard[1:20, :]

Adv23OffPassing = select(OffAdv23, :Team, :OffPassDownPer => DivByMean, :OffPassDownPPA => DivByMean, 
:OffPassDownSuccess => DivByMean, :OffPassDownExpl => DivByMean, renamecols=false)
Adv23OffPassing = Adv23OffPassing[1:20, :]

Def23General = select(AdvDef23, :Team, :DefPPA => DivByMean, :DefSucess => DivByMean, :DefExplosive => DivByMean, renamecols=false)
Def23General = Def23General[1:20, :]
#Team name vectors for x ticks
OffTop20Names = Adv23General.Team
DefTop20Names = Def23General.Team

#Plotting functions split by number of stats 
function VizTwo(Title::String, TeamNames, Stat1, Stat2, Label1::String, Label2::String, FileName::String)
    Plot = Figure(size=(1080,720))
    ax = Axis(Plot[1,1],
        title = "$Title",
        xlabel = "Teams",
        ylabel = "Rating Below/Above Average",
        xticks = (1:1:20, TeamNames),
        xticklabelrotation = pi/2
)

    scatter!(Stat1, markersize=15, label = "$Label1")
    scatter!(Stat2, markersize=15, label = "$Label2")
    hlines!(1.0, label = "Average")
    axislegend()
    save("$FileName", Plot)
end

VizTwo("Open Field Stats from top 20 Points Per Oppurtunity Teams", OffTop20Names, Adv23OffOpenField.OffSecondLvl,
Adv23OffOpenField.OffOpenField, "2nd Level Yards", "Open Field Yars", "OffOpenField.png")

function VizThree(Title::String, TeamNames, Stat1, Stat2, Stat3, Label1::String, Label2::String, Label3::String, FileName::String)
    Plot = Figure(size=(1080,720))
    ax = Axis(Plot[1,1],
        title = "$Title",
        xlabel = "Teams",
        ylabel = "Rating Below/Above Average",
        xticks = (1:1:20, TeamNames),
        xticklabelrotation = pi/2
)

    scatter!(Stat1, markersize=15, label = "$Label1")
    scatter!(Stat2, markersize=15, label = "$Label2")
    scatter!(Stat3, markersize=15, label = "$Label3")
    hlines!(1.0, label = "Average")
    axislegend()
    save("$FileName", Plot)
end

VizThree("General Off Stats from top 20 Points Per Oppurtunity Teams", OffTop20Names, Adv23General.OffPPA,
Adv23General.OffSucces, Adv23General.OffExplosive, "PPA", "Success Rate", "Explosiveness", "OffGeneral.png")

VizThree("OLine Stats from top 20 Points Per Oppurtunity Teams", OffTop20Names, Adv23OffLine.OffPower,
Adv23OffLine.OffStuff, Adv23OffLine.OffLineYards, "Power Success", "Stuff Rate", "Line Yards", "OffLine.png")

VizThree("Off Havoc Stats from top 20 Points Per Oppurtunity Teams", OffTop20Names, Adv23OffHavoc.OffHavoc,
Adv23OffHavoc.OffHavocFront, Adv23OffHavoc.OffHavocDB, "Total", "Front Seven", "DB", "OffHavoc.png")

VizThree("General Def Stats from top 20 Points Per Oppurtunity Teams", DefTop20Names, Def23General.DefPPA,
Def23General.DefSucess, Def23General.DefExplosive, "PPA", "Success Rate", "Explosiveness", "DefGeneral.png")


function VizFour(Title::String, TeamNames, Stat1, Stat2, Stat3, Stat4, Label1::String, Label2::String, Label3::String, Label4::String, FileName::String)
    Plot = Figure(size=(1080,720))
    ax = Axis(Plot[1,1],
        title = "$Title",
        xlabel = "Teams",
        ylabel = "Rating Below/Above Average",
        xticks = (1:1:20, TeamNames),
        xticklabelrotation = pi/2
)

    scatter!(Stat1, markersize=15, label = "$Label1")
    scatter!(Stat2, markersize=15, label = "$Label2")
    scatter!(Stat3, markersize=15, label = "$Label3")
    scatter!(Stat4, markersize=15, label = "$Label4")
    hlines!(1.0, label = "Average")
    axislegend()
    save("$FileName", Plot)
end

VizFour("Off Standard Down from top 20 Points Per Oppurtunity Teams", OffTop20Names, Adv23OffPassing.OffPassDownPer,
Adv23OffStandard.OffStandardDownPPA, Adv23OffStandard.OffStandardSuccess, Adv23OffStandard.OffStandardExpl,
"% of Standard Downs", "PPA", "Success Rate", "Explosiveness", "OffStandardDown.png")

VizFour("Off Pass Down Stats from top 20 Points Per Oppurtunity Teams", OffTop20Names, Adv23OffPassing.OffPassDownPer,
Adv23OffPassing.OffPassDownPPA, Adv23OffPassing.OffPassDownSuccess, Adv23OffPassing.OffPassDownExpl,
"% of Pass Downs", "Pass Down PPA", "Pass Down Success Rate", "Pass Down Explosiveness", "OffPassDown.png")

