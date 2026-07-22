import 'habit_notifications.dart';

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
  static const List<String> romantic = HabitNotifications.romantic;


  // 🙄 Roast / Sarcastic
  static final List<String> roast = HabitNotifications.roast
      .map((msg) => msg
          .replaceAll("rahe ho kya?", "rahi ho kya?")
          .replaceAll("gaya, wapas hi nahi aaya", "gayi thi, wapas hi nahi aayi")
          .replaceAll("start karunga", "start karungi"))
      .toList();

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
  static final List<String> breakup = HabitNotifications.breakup
      .map((msg) => msg
          .replaceAll("kar rahi thi, bhool gaye", "kar raha tha, bhool gayi")
          .replaceAll("bhool gaye", "bhool gayi")
          .replaceAll("kar rahi hoon", "kar raha hoon"))
      .toList();

  // 📏 Discipline / Consistency
  static final List<String> discipline = HabitNotifications.discipline
      .map((msg) => msg.replaceAll("thank karoge", "thank karogi"))
      .toList();

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
