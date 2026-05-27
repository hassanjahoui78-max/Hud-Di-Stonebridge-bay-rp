local Translations = {
    notify = {
        seatbelt_on = "Cintura allacciata!",
        seatbelt_off = "Cintura slacciata!",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})