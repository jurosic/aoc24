#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>

std::vector<int> split(const std::string& str, char delimiter) {
    std::vector<int> tokens;
    std::stringstream ss(str);
    std::string token;
    while (std::getline(ss, token, delimiter)) {
        //convert to int and push to vector
        tokens.push_back(std::atoi(token.c_str()));
    }
    return tokens;
}

int main() {
    std::ifstream file("5.txt");
    if (!file.is_open()) {
        std::cerr << "Failed to open the file." << std::endl;
        return 1;
    }

    std::vector<std::vector<int>> rules;
    std::vector<std::vector<int>> pages;

    std::vector<std::vector<int>> correct_pages;


    std::vector<std::vector<std::string>> lines;
    std::string line;
    bool rule_mode = true;
    while (std::getline(file, line)) {
        if (line == ""){
            rule_mode = false;
        }

        if (rule_mode){
            rules.push_back(split(line, '|'));
        } else {
            pages.push_back(split(line, ','));
        }
    }

    file.close();
//---------------------------------------------

    bool correct = true;

    for (int i = 0; i < pages.size(); i++){
        for (int j = 0; j < pages[i].size(); j++){
            for (int k = 0; k < rules.size(); k++){
                if (rules[k][0] == pages[i][j]){
                    if (std::find(pages[i].begin(), pages[i].end(), rules[k][1]) != pages[i].end()){
                        int found_index = std::find(pages[i].begin(), pages[i].end(), rules[k][1]) - pages[i].begin();
                        //std::cout << "found: " << rules[k][1] << " at index: " << found_index << std::endl;
                        //std::cout << pages[i][j] << " should be before: " << pages[i][found_index] << std::endl;
                        if (j > found_index){
                            correct = false;
                            //std::cout << "Page " << i+1 << " has a rule violation." << std::endl;
                            int at_found = pages[i][found_index];
                            pages[i][found_index] = pages[i][j];
                            pages[i][j] = at_found;
                        }
                    }
                }
            }
        }
        if (correct){
            correct_pages.push_back(pages[i]);
        }
        correct = true;
    }

    //put pages to std::cout
    for (int i = 0; i < correct_pages.size(); i++){
        //std::cout << "Page " << i+1 << ": ";
        for (int j = 0; j < correct_pages[i].size(); j++){
            std::cout << correct_pages[i][j] << " ";
        }
        std::cout << std::endl;
    }

    int result = 0;

    for (int i = 0; i < correct_pages.size(); i++){
        //find midpoint of the page
        int midpoint = correct_pages[i].size() / 2;
        if (midpoint != 0){
            result += correct_pages[i][midpoint];
        }
    }

    std::cout << "Result: " << result << std::endl;

    return 0;
}