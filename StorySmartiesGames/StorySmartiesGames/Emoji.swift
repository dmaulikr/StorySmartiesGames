//
//  Emoji.swift
//  StorySmartiesCore
//
//  Created by Daniel Asher on 16/11/2016.
//  Copyright © 2016 LEXI LABS. All rights reserved.
//

import Foundation

/// CommonEmoji at your fingertips.
// TODO: ⚠️ Figure out why more emoji can be case names in playgrounds than in a project file. Missing are:
// Stars: ⭐️,🌟,💫,✨,☄️,🌠,🎇,🎆,🌈,🎲,🚀
// Weather: ☀️,🌤,⛅️,🌥,🌦,☁️,🌧,⛈,🌩,⚡️,❄️,🌨,🌊,🌪,🔅,🔆
// Hearts: ❤️,💛,💚,💙,💜,❣️,💕,💞,💓,💗,💖,💘,💝
// Symbols: 🚫,❌,⭕️,💢,♨️,❗️,❕,❓,❔,‼️,⁉️,💯
//          ⚠️,🚸,❎,✅,Ⓜ️,🌀
//          📝,✏️,🔍,🔎
//          ▶️,⏯,⏸,⏹,⏺,⏮,⏭,➡️,⬅️,⬆️,⬇️,↪️,↩️
//          🔃,🎵,🎶,〰️,➰,✔️,➕,➖,✖️,🔚,🔙,🔛,🔝,🔜

public enum Emoji {
    public enum Faces : String {
        case 😀,😬,😁,😂,😃,😄,😅,😆,😇,😉,😊,🙂,🙃
        case 😋,😌,😍,😘,😗,😙,😚,😜,😝,😛,🤑,🤓
        case 😎,🤗,😏,😶,😐,😑,😒,🙄,🤔,😳,😞,😟,😠
        case 😡,😔,😕,🙁,😣,😖,😫,😩,😤,😮,😱,😨
        case 😰,😯,😦,😧,😢,😥,😪,😓,😭,😵,😲,🤐,😷
        case 🤒,🤕,😴,💩,👹
    }
    public enum Hands : String {
        case 🙌,👏,👍,👎,👊
        case 👋,👉,👆,👇,👌
        case 👐,💪,🙏,🖖,🤘,🖕
    }
    public enum Animals : String {
        case 🦁,🐼,🐦,🐤,🐣,🐥,🦄,🐝,🐛,🐞,🐍,🐢,🐬,🐾,🐉,🕊
    }
    public enum People : String {
        case 👁,👀,🗣,👤,👥,🙋,🙆
    }
    public enum Flowers : String {
        case 🌺,🌻,🌹,🌷,🌼,🌸,💐,🍄
    }
    public enum Stars : String {
        case 🌠,🎇,🎆,🌈,🎲,🚀
    }
    public enum Weather : String {
        case 🌪,🔅,🔆
    }
    public enum Medals : String {
        case 🕴,🎗,🏅,🎖,🏆,🏵,🎯
    }
    public enum Media : String {
        case 🎬,🎤,🎧,🎼,🎹,🎥,📽,🕹,📱,📲
    }
    public enum Activity : String {
        case 🔌
    }
    public enum Celebration : String {
        case 💡,💎,🎁,🎈,🎀,🎊,🎉
    }
    public enum Message : String {
        case 📨,💌,📥,📤,🔖,🏷
    }
    public enum Charts : String {
        case 📜,📃,📄,📊,📈,📉,🗒,🗓,🗞,📰
    }
    public enum Books : String {
        case 📒,📕,📗,📘,📙,📚,📖
    }
    public enum Pins : String {
        case 🔗,📎,🖇,📌,📍,🚩,🏳️,🏴,🏁,🏳️‍🌈
    }
    public enum Hearts : String {
        case 💙,💜,💕,💞,💓,💗,💖,💘,💝
    }
    public enum Symbols : String {
        case 🚫, 💯
        case 🔍,🔎
        case 🔃,🔝,🔜, 🔚
        case 🔴,🔵,🔺,🔻,🔸,🔹,🔶,🔷
        case 🔇,🔈,🔉,🔊
        case 💬,💭,🗯
    }
}
