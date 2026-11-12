---
name: code-is-too-deep
description: Använd när användaren säger åt dig att göra det
---

Jag tycker ofta att det blir att kod ser ut såhär:

def do_something():
    prepare_a_bit()
    prepare_some_more()
    main_thing()
    do_some_cleanup()

def main_thing():
    more_preparation()
    a_little_functionality()
    majority_of_stuff_happens_here()
    more_cleanup()

osv, så man måste köra goto definition väldigt många gånger för att se vad som faktiskt händer.
Det är mycket mer nice när koden ser ut typ:

def do_something():
    res_1 = do_step_1()
    res_2 = do_step_2()
    res_3 = do_step_3(res_2, res_1)

typ. Det går ju inte alltid att exakt göra så fint men du fattar poängen.
Man vill lätt kunna få en överblick över det viktiga i en metod och man vill ha en ganska delad abstraktionsnivå.
