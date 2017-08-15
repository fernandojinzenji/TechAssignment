//
//  BattleViewController.swift
//  AequilibriumTechAssignments
//
//  Created by Fernando Jinzenji on 2017-08-14.
//  Copyright © 2017 Fernando Jinzenji. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var selectedAutobots = [Transformer]()
    var selectedDecepticons = [Transformer]()
    
    var numberOfBattles = 0
    var autobotWinCount = 0
    var decepticonWinCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Sort both arrays by rank
        self.selectedAutobots = sortByRank(array: self.selectedAutobots)
        self.selectedDecepticons = sortByRank(array: self.selectedDecepticons)
        
//        self.selectedAutobots.removeAll()
//        self.selectedDecepticons.removeAll()
//        self.selectedAutobots.append(Transformer(pName: "auto", pType: .Autobot, pStrength: 5, pIntelligence: 5, pSpeed: 5, pEndurance: 5, pRank: 5, pCourage: 5, pFirepower: 5, pSkill: 5))
//        self.selectedDecepticons.append(Transformer(pName: "dece", pType: .Decepticon, pStrength: 5, pIntelligence: 5, pSpeed: 5, pEndurance: 5, pRank: 5, pCourage: 5, pFirepower: 5, pSkill: 5))
        
        
        // Get number of battles (biggest array)
        self.numberOfBattles = (self.selectedAutobots.count < self.selectedDecepticons.count) ? self.selectedAutobots.count : self.selectedDecepticons.count
        
//        // Fight robots
//        for i in 0 ..< self.numberOfBattles {
//            
//            let autobot = self.selectedAutobots[i]
//            let decepticon = self.selectedDecepticons[i]
//            
//            // SPECIAL RULE: if Optimus Prime encounter Predaking, the game ends immediately. Otherwise, both wins against everyone else
//            if autobot.name == "Optimus Prime" && decepticon.name == "Predaking" {
//                print("clash")
//                break;
//            }
//            else if autobot.name == "Optimus Prime" {
//                self.autobotWins += 1
//                break;
//            }
//            else if decepticon.name == "Predaking" {
//                self.decepticonWins += 1
//                break;
//            }
//            
//            // RULE 1: If robot is stronger (3 or more strength points) but coward (4 or less courage points), oponent wins
//            if autobot.strength - decepticon.strength >= 3 && decepticon.courage - autobot.courage >= 4 {
//                self.decepticonWins += 1
//                break;
//            }
//            else if decepticon.strength - autobot.strength >= 3 && autobot.courage - decepticon.courage >= 4 {
//                self.autobotWins += 1
//                break;
//            }
//            
//            // RULE 2: If robot is 3 or more points of skill, it wins the fight
//            if autobot.skill - decepticon.skill >= 3 {
//                self.autobotWins += 1
//                break;
//            }
//            else if decepticon.skill - autobot.skill >= 3 {
//                self.decepticonWins += 1
//                break;
//            }
//            
//            // RULE 3: Winner is the robot with bigger overall rating
//            if autobot.overallRating > decepticon.overallRating {
//                self.autobotWins += 1
//            }
//            else if decepticon.overallRating > autobot.overallRating {
//                self.decepticonWins += 1
//            }
//        }
        
//        if self.autobotWins > self.decepticonWins {
//            self.navigationBar.items?[0].title = "Autobots Win!"
//        }
//        else if self.decepticonWins > self.autobotWins {
//            self.navigationBar.items?[0].title = "Decepticon Win!"
//        }
//        else {
//            self.navigationBar.items?[0].title = "Tie!"
//        }
    }
    
    // MARK: Actions

    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfBattles
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "battle-cell") as! BattleTableViewCell

        let autobot = self.selectedAutobots[indexPath.row]
        let decepticon = self.selectedDecepticons[indexPath.row]
        
        // Robot names
        cell.autobotName.text = autobot.name
        cell.decepticonLabel.text = decepticon.name
        
        // Make robots clash
        let battle = Battle(pAutobot: autobot, pDecepticon: decepticon)
        battle.fight()
        
        // Show trophy to winner
        switch battle.winner {
        case .autobot:
            cell.autobotTrophy.isHidden = false
            cell.decepticonTrophy.isHidden = true
        case .decepticon:
            cell.autobotTrophy.isHidden = true
            cell.decepticonTrophy.isHidden = false
        case .tie:
            cell.autobotTrophy.isHidden = true
            cell.decepticonTrophy.isHidden = true
        default:
            cell.autobotTrophy.isHidden = true
            cell.decepticonTrophy.isHidden = true
        }
        
        // Show the battle number and explain why the robot won
        cell.battleDetail.text = "Battle \(indexPath.row + 1): "
        switch battle.winnerDetail {
        case .optimus:
            cell.battleDetail.text! += "Optimus always wins"
        case .predaking:
            cell.battleDetail.text! += "Predaking always wins"
        case .strongButCoward:
            cell.battleDetail.text! += "Stronger, but coward"
        case .skill:
            cell.battleDetail.text! += "Skill points"
        case .overallRating:
            cell.battleDetail.text! += "Overall rating"
        default:
            cell.battleDetail.text! += "N/A"
        }
        
        return cell
    }
    
    // MARK: Private Methods
    
    func sortByRank(array: [Transformer]) -> [Transformer] {
        
        return array.sorted(by: { (t1, t2) -> Bool in
            return t1.rank < t2.rank
        })
        
    }
    
}
