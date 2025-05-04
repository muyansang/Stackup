//
//  NetworkManager.swift
//  A4
//
//  Created by Steven Wei Chen on 4/26/25.
//
import Foundation
import UIKit



class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private let baseURL = "http://127.0.0.1:5000/api"

    func fetchTasks(for projectId: String, date: Date, completion: @escaping ([Task]) -> Void) {
        guard let dayIndex = computeDayIndex(from: date),
              let url = URL(string: "\(baseURL)/projects/\(projectId)/days/\(dayIndex)/tasks") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let tasks = try? JSONDecoder().decode([Task].self, from: data) {
                completion(tasks)
            } else {
                completion([])
            }
        }.resume()
    }


    func postTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        let projectId = task.projectId
        guard let dayIndex = computeDayIndex(from: task.date),
              let url = URL(string: "\(baseURL)/projects/\(projectId)/days/\(dayIndex)/tasks") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(task)
            request.httpBody = jsonData
        } catch {
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            completion(error == nil)
        }.resume()
    }

    func deleteTask(taskId: Int, completion: (() -> Void)? = nil) {
        guard let url = URL(string: "\(baseURL)/tasks/\(taskId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion?()
        }.resume()
    }

    func deleteProject(projectId: String, completion: (() -> Void)? = nil) {
        guard let url = URL(string: "\(baseURL)/projects/\(projectId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion?()
        }.resume()
    }
    
    private func computeDayIndex(from dateString: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let targetDate = formatter.date(from: dateString) else { return nil }
        return computeDayIndex(from: targetDate)
    }

    private func computeDayIndex(from date: Date) -> Int? {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTarget = calendar.startOfDay(for: date)
        let days = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget).day
        return days
    }
    
    func postProject(_ project: ProjectModel, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/projects") else {
            completion(false)
            return
        }

        struct RequestBody: Codable {
            let name: String
            let short_id: String
            let color: String
        }

        let body = RequestBody(
            name: project.name,
            short_id: project.shortId,
            color: project.color.hexString
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse {
                completion(httpResponse.statusCode == 200 || httpResponse.statusCode == 201)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    func updateTaskPriority(_ task: Task) {
        guard let id = task.id else { return }
        let url = URL(string: "\(baseURL)/tasks/\(id)/priority")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["priority": task.priority]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request).resume()
    }
    
    func fetchProjectById(_ projectId: String, completion: @escaping (ProjectModel?) -> Void) {
        guard let url = URL(string: "\(baseURL)/projects/by_short_id/\(projectId)") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ProjectResponse.self, from: data)

                let model = ProjectModel(
                    id: UUID(),
                    name: decoded.project.name,
                    color: UIColor(hex: decoded.project.color),
                    shortId: decoded.project.short_id,
                    startDate: Date(),
                    tasks: []
                )
                completion(model)
            } catch {
                completion(nil)
            }

        }.resume()
    }


    struct DecodableProject: Codable {
        let name: String
        let short_id: String
        let color: String
    }

    struct ProjectResponse: Codable {
        let project_id: String
        let project: DecodableProject
    }



}
