// 🎯 NEGOTIATION PRACTICE SIMULATOR - INTERACTIVE SCENARIOS
// Run this in a browser console or Node.js to practice investor negotiations

const NegotiationSimulator = {
  // Scenario 1: Valuation Negotiation
  scenarios: [
    {
      id: "valuation_pressure",
      title: "Investor Pushing for Lower Valuation",
      investor: "Oak HC/FT Partner",
      context: "They love the business but think your $8M post-money valuation is high for a seed round",
      dialogue: [
        {
          speaker: "investor",
          message: "We love what you're building, but $8M post-money feels aggressive for seed stage. We're thinking more like $5-6M range."
        },
        {
          speaker: "user",
          options: [
            {
              text: "We can be flexible - what works for you?",
              feedback: "❌ Too weak - you're immediately caving without justification",
              score: 2
            },
            {
              text: "Let me show you why $8M is justified - we're production-ready with 82% cost reduction targeting $496B market",
              feedback: "✅ Strong response - anchors to value before discussing flexibility",
              score: 8
            },
            {
              text: "That's too low - we won't go below $7M",
              feedback: "⚠️ Too rigid - you haven't justified your valuation yet",
              score: 5
            }
          ]
        },
        {
          speaker: "investor",
          message: "I understand the market size, but you're pre-revenue. Most seed-stage companies with no revenue are valued at $4-6M.",
          options: [
            {
              text: "But our technology is more advanced than typical seed companies",
              feedback: "❌ Weak justification - needs specific evidence",
              score: 3
            },
            {
              text: "We're not typical seed - we're production-ready processing $247K MRR with 42% month-over-month growth",
              feedback: "✅ Excellent - uses real metrics to justify premium valuation",
              score: 9
            },
            {
              text: "What if we do $6.5M?",
              feedback: "⚠️ Negotiating too early - justify first, then negotiate",
              score: 4
            }
          ]
        }
      ]
    },
    
    // Scenario 2: Board Seat Negotiation
    {
      id: "board_seat_demand",
      title: "Investor Demanding Board Seat",
      investor: "NEA Partner",
      context: "They want to take a board seat for their seed investment",
      dialogue: [
        {
          speaker: "investor",
          message: "For our $1.5M investment, we'd need a board seat. That's standard for our seed investments."
        },
        {
          speaker: "user",
          options: [
            {
              text: "Okay, you can have a board seat",
              feedback: "❌ Too quick - board seats are valuable and shouldn't be given away easily",
              score: 3
            },
            {
              text: "We're planning to keep the board small at this stage - would board observer rights work instead?",
              feedback: "✅ Smart counter-offer - preserves control while giving them visibility",
              score: 8
            },
            {
              text: "We don't want any investors on the board right now",
              feedback: "⚠️ Too rigid - might kill the deal without exploring options",
              score: 5
            }
          ]
        },
        {
          speaker: "investor",
          message: "Board observer is better, but we really need voting rights to protect our investment. What about a board seat that expires at Series A?",
          feedback: "✅ This is a reasonable compromise - time-limited board seat",
          options: [
            {
              text: "That could work - let's discuss the specific terms",
              feedback: "✅ Good response - open to reasonable compromise",
              score: 8
            },
            {
              text: "No board seats at all, final answer",
              feedback: "❌ Too rigid - you might lose the investment",
              score: 2
            },
            {
              text: "What if you get observer rights plus pro-rata rights instead?",
              feedback: "✅ Creative alternative - addresses their underlying concern",
              score: 9
            }
          ]
        }
      ]
    },
    
    // Scenario 3: Liquidation Preference
    {
      id: "liquidation_preference",
      title: "Investor Wants 2x Liquidation Preference",
      investor: "Lux Capital Partner",
      context: "They're asking for 2x liquidation preference in the term sheet",
      dialogue: [
        {
          speaker: "investor",
          message: "We need 2x liquidation preference to protect our investment. This is standard for our seed deals.",
          speaker: "user",
          options: [
            {
              text: "Okay, 2x liquidation preference is fine",
              feedback: "❌ Never accept 2x preference at seed - it's terrible for founders",
              score: 1
            },
            {
              text: "2x is too high - we can do 1x non-participating preference",
              feedback: "✅ Strong response - establishes market standard",
              score: 8
            },
            {
              text: "What about 1.5x?",
              feedback: "⚠️ Still too high - 1x is the market standard for seed",
              score: 4
            }
          ]
        },
        {
          speaker: "investor",
          message: "We're taking significant risk at this stage. 1x doesn't adequately protect us.",
          options: [
            {
              text: "I understand the risk, but 1x is market standard for seed. We can offer other protections instead.",
              feedback: "✅ Acknowledges their concern while holding firm on market terms",
              score: 9
            },
            {
              text: "The risk is why you get equity - 1x preference is fair",
              feedback: "⚠️ A bit confrontational - could be phrased better",
              score: 6
            },
            {
              text: "What if we do 1x with a 20% discount on next round?",
              feedback: "✅ Creative alternative - addresses their risk concern",
              score: 8
            }
          ]
        }
      ]
    },
    
    // Scenario 4: Pro-Rata Rights
    {
      id: "pro_rata_rights",
      title: "Investor Demanding Full Pro-Rata Rights",
      investor: "Khosla Ventures Partner",
      context: "They want guaranteed pro-rata rights in future rounds",
      dialogue: [
        {
          speaker: "investor",
          message: "We need full pro-rata rights to maintain our ownership percentage in future rounds.",
          options: [
            {
              text: "Of course, you can have pro-rata rights",
              feedback: "⚠️ Be careful - pro-rata rights can limit your ability to bring in other investors",
              score: 5
            },
            {
              text: "We can offer pro-rata rights subject to the next lead investor's approval",
              feedback: "✅ Smart compromise - gives them rights while preserving flexibility",
              score: 9
            },
            {
              text: "We don't offer pro-rata rights to seed investors",
              feedback: "❌ Too rigid - pro-rata is common and reasonable",
              score: 3
            }
          ]
        },
        {
          speaker: "investor",
          message: "Subject to lead approval doesn't guarantee us anything. We need firm pro-rata rights.",
          options: [
            {
              text: "Let me think about it - can we come back to this after discussing other terms?",
              feedback: "✅ Good tactic - defers difficult negotiation while building goodwill",
              score: 8
            },
            {
              text: "What if we guarantee pro-rata up to $500K, then subject to lead approval above that?",
              feedback: "✅ Creative compromise - balances their needs with your flexibility",
              score: 9
            },
            {
              text: "Take it or leave it on pro-rata rights",
              feedback: "❌ Too aggressive - could kill the deal",
              score: 2
            }
          ]
        }
      ]
    },
    
    // Scenario 5: Founder Vesting
    {
      id: "founder_vesting",
      title: "Investor Wants 4-Year Founder Vesting",
      investor: "Andreessen Horowitz Partner",
      context: "They want all founders to have 4-year vesting with 1-year cliff",
      dialogue: [
        {
          speaker: "investor",
          message: "We need to see all founders on 4-year vesting with a 1-year cliff. That's standard to protect the company.",
          options: [
            {
              text: "No problem, we'll do 4-year vesting with 1-year cliff",
              feedback: "✅ This is actually standard and reasonable - shows you're aligned",
              score: 8
            },
            {
              text: "We've been working for 2 years already - can we get credit for that?",
              feedback: "✅ Excellent point - you should get credit for prior work",
              score: 9
            },
            {
              text: "We won't do vesting - we've been working too long already",
              feedback: "❌ Unreasonable - vesting protects everyone including founders",
              score: 2
            }
          ]
        },
        {
          speaker: "investor",
          message: "We can give you credit for 2 years of work, so you'd have 2 years remaining. Does that work?",
          options: [
            {
              text: "That sounds fair - 2 years remaining with no cliff since we're already past that",
              feedback: "✅ Perfect - reasonable compromise that acknowledges your contribution",
              score: 9
            },
            {
              text: "We want 1 year remaining - we've already proven our commitment",
              feedback: "⚠️ A bit aggressive - 2 years remaining is very fair",
              score: 6
            },
            {
              text: "What if we do 3 years remaining but with accelerated vesting on acquisition?",
              feedback: "✅ Creative - addresses their concern while protecting founders",
              score: 8
            }
          ]
        }
      ]
    }
  ],
  
  // Practice function
  practiceScenario: function(scenarioId) {
    const scenario = this.scenarios.find(s => s.id === scenarioId);
    if (!scenario) {
      console.log("Scenario not found. Available scenarios:");
      this.scenarios.forEach(s => console.log(`- ${s.id}: ${s.title}`));
      return;
    }
    
    console.log(`\n🎯 ${scenario.title}`);
    console.log(`👥 ${scenario.investor}`);
    console.log(`📝 ${scenario.context}\n`);
    
    let totalScore = 0;
    let maxScore = 0;
    
    scenario.dialogue.forEach((exchange, index) => {
      console.log(`\n--- Round ${index + 1} ---`);
      console.log(`🎙️  ${scenario.investor}: "${exchange.message}"`);
      
      if (exchange.speaker === "user" && exchange.options) {
        console.log("\nYour response options:");
        exchange.options.forEach((option, i) => {
          console.log(`${i + 1}. "${option.text}"`);
        });
        
        // In real practice, user would choose. For demo, we'll show best response:
        const bestOption = exchange.options.reduce((best, current) => 
          current.score > best.score ? current : best
        );
        
        console.log(`\n💡 Best response: "${bestOption.text}"`);
        console.log(`📊 ${bestOption.feedback}`);
        console.log(`🎯 Score: ${bestOption.score}/10`);
        
        totalScore += bestOption.score;
        maxScore += 10;
      }
      
      if (exchange.feedback) {
        console.log(`\n💭 ${exchange.feedback}`);
      }
    });
    
    const finalScore = Math.round((totalScore / maxScore) * 100);
    console.log(`\n🏆 Final Score: ${finalScore}%`);
    
    if (finalScore >= 90) {
      console.log("🌟 EXCELLENT! You're ready for real negotiations!");
    } else if (finalScore >= 70) {
      console.log("👍 GOOD! With practice, you'll be great!");
    } else {
      console.log("📚 KEEP PRACTICING! Review the feedback and try again.");
    }
  },
  
  // Quick practice mode
  quickPractice: function() {
    console.log("🚀 QUICK PRACTICE MODE\n");
    console.log("Top 5 negotiation scenarios:\n");
    
    this.scenarios.forEach((scenario, index) => {
      console.log(`${index + 1}. ${scenario.title}`);
      console.log(`   Key issue: ${scenario.context}`);
      console.log(`   Practice with: practiceScenario("${scenario.id}")\n`);
    });
    
    console.log("💡 Pro tip: Practice each scenario 3 times for best results!");
  },
  
  // Score tracking
  scores: {},
  
  trackScore: function(scenarioId, score) {
    if (!this.scores[scenarioId]) {
      this.scores[scenarioId] = [];
    }
    this.scores[scenarioId].push(score);
    
    const average = this.scores[scenarioId].reduce((a, b) => a + b, 0) / this.scores[scenarioId].length;
    console.log(`📈 ${scenarioId} average score: ${Math.round(average)}% (${this.scores[scenarioId].length} attempts)`);
  }
};

// Export for use
if (typeof module !== 'undefined' && module.exports) {
  module.exports = NegotiationSimulator;
} else {
  // Browser environment
  window.NegotiationSimulator = NegotiationSimulator;
}

// Auto-start quick practice
console.log("🎯 NEGOTIATION PRACTICE SIMULATOR LOADED");
console.log("Type 'NegotiationSimulator.quickPractice()' to see scenarios");
console.log("Type 'NegotiationSimulator.practiceScenario(\"valuation_pressure\")' to practice");

// Example usage:
// NegotiationSimulator.quickPractice();
// NegotiationSimulator.practiceScenario("valuation_pressure");
