// ============================================================
// Variant for female users (voice/tone written as if from a guy)
// ============================================================
class HabitNotificationsForHer {
  // 💘 Flirty
  static const List<String> flirty = [
    "Aaj bhi miss kar diya? Wait kar raha tha tumhara 😏",
    "Thoda time nikaalo mere liye, matlab apni habit ke liye 😉",
    "Consistency cute lagti hai tumpe, pata hai na? 😘",
    "Jitna ignore karogi, utna hi pareshan karunga 🫣",
    "Ek baar kar ke dekho, addict ho jaogi mere jaise 💋",
    "Roz milne ka wada tha na? Nibhao zara 🌹",
    "Aaj bhi late aaogi kya mujhse milne? ⏰",
    "Mera intezaar khatam karo, streak pura karo 💘",
    "Tumhari attention chahiye, roz thodi si 🥺",
    "Itna nakhra? Bas 2 minute mange hain 🙄",
    "Mujhse door raho par habit se nahi 🎯",
    "Aaj bhi bhaav kha rahi ho mujhe? 😏",
  ];

  // ❤️ Romantic
  static const List<String> romantic = [
    "Har din thoda better bano, proud hona hai tumpe ❤️",
    "Roz karne se pyaar jhalakta hai, chhoti si cheez hai 💕",
    "Tumhara best version dekhna chahta hoon main 🌟",
    "Wahi promise nibhao jo khud se kiya tha ✨",
    "Ye ek chhota sa vaada tha, yaad hai na? 🤝",
    "Tumhari growth dekhkar sukoon milta hai 🧿",
    "Khud se kiya pyaar, isi se dikhta hai 🌸",
    "Aaj bhi apna khayal rakhna, ek kadam aur 💫",
    "Tumhare liye hi ye reminder bheja hai 💌",
    "Chalo saath mein aaj ka goal pura karein 🎯",
  ];

  // 🙄 Roast / Sarcastic
  static const List<String> roast = [
    "Wah! Fir se skip? Records bana rahi ho kya? 🙄",
    "Motivation dhoondhne gayi thi, wapas hi nahi aayi 🥱",
    "Kal se start karungi - 47th baar sun raha hoon 🤡",
    "Itni excuses Bollywood scripts mein bhi nahi hoti 🎬",
    "Streak aur patience dono khatam ho rahe hain 💀",
    "App download kiya ya storage bharne ke liye? 💾",
    "Tumhara 'kal se' wala kal kabhi aayega? ⏳",
    "Naam habit tracker, kaam excuse tracker 🤐",
    "Itna toh Monday motivation bhi nahi tikta 📉",
    "Fir se snooze? Talent hai tumme ye 💤",
    "Discipline ki jagah drama zyada hai 🎭",
  ];

  // 🥺 Cute / Shona
  static const List<String> cute = [
    "Shona, aaj wali habit bhool gayi kya? 🥺",
    "Ek chhota kaam hai jaan, kar lo na please 🥹",
    "Pyaari si yaad dilaane wali reminder 💕",
    "Chalo utho, streak todna mana hai! 🧸",
    "Jaan please, sirf 5 minute ka kaam hai 🌸",
    "Tumhare bina streak adhoora lagta hai 🥹",
    "Bas ek baar kar lo, phir so jaana 😴",
    "Meri taraf se ek pyaara sa push, chalo! 🚀",
    "Itna cute reminder bhi kaam nahi karega? 🫣",
    "Chhoti si request hai jaan, maan lo na 🥺",
  ];

  // 🔥 Motivational
  static const List<String> motivational = [
    "Champions din nahi chhodte, tum bhi mat chhodo 🔥",
    "Ek din ki mehnat, kal ka result banati hai ⚡",
    "Jo aaj karogi, wahi kal alag banayega 🌟",
    "Small steps, big changes. Aaj wala step lo 👣",
    "Future self wait kar raha hai tumhara 📈",
    "Discipline > Motivation. Bas kar do 🦾",
    "Har din ek naya mauka hai better banne ka 🚀",
    "Tumhari mehnat kabhi waste nahi jaati 💎",
    "Aaj ka effort, kal ki success hai 👑",
    "Winners roz dikhti hain, excuses nahi deti 🏆",
  ];

  // 💔 Breakup Style (guilt-trip tone)
  static const List<String> breakup = [
    "Tumne mujhse (habit se) breakup kar liya kya? 💔",
    "3 din se baat nahi hui, sab theek hai na? 😢",
    "Wapas aane ka wait kar raha tha, bhool gayi 🥀",
    "Rishta tabhi chalta hai jab effort dono se ho 🤝",
    "Lagta hai ab meri zarurat nahi rahi 🤫",
    "Ek reminder aur bhejoon, ya samajh jao? 💬",
    "Humara connection toot raha hai dheere dheere 📉",
    "Itni jaldi bhool gayi humara roz ka wada? 😔",
    "Main abhi bhi wait kar raha hoon tumhara ⌛",
  ];

  // 📏 Discipline / Consistency
  static const List<String> discipline = [
    "Discipline talent se zyada powerful hota hai 🧠",
    "Streak: {X} din. Isse tootne mat dena 🎯",
    "Chhoti aadatein badi tabdeeli laati hain 📈",
    "Aaj miss mat karo, kal khud ko thank karogi ⏳",
    "Consistency hi asli talent hai 💎",
    "Ek din ka gap, mahine ki mehnat barbaad karta hai 📉",
    "Roz ka thoda sa, hamesha ka bahut sa banta hai 📊",
    "Habit banao, motivation ki zarurat khatam karo ⚙️",
    "Aaj ka commitment, kal ka character hai 🛡️",
    "Break mat lo, streak hi tumhara pehchaan hai 🏆",
  ];

  static Map<String, List<String>> get allCategories => {
        'flirty': flirty,
        'romantic': romantic,
        'roast': roast,
        'cute': cute,
        'motivational': motivational,
        'breakup': breakup,
        'discipline': discipline,
      };
}
