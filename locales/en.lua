local Translations = {
    notify = {
        seatbelt_on = "Seatbelt fastened!",
        seatbelt_off = "Seatbelt unfastened!",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})