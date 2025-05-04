//
//  ProjectViewController.swift
//  A4
//
//  Created by muyan on 5/1/25.
//


import UIKit
import Foundation

class ProjectViewController: UIViewController, AddProjectOverlayDelegate, JoinProjectOverlayDelegate {
    private var projectView: ProjectView!

    private var projects: [ProjectModel] = [] {
        didSet {
            projectView.updateProjects(projects)
        }
    }

    override func loadView() {
        projectView = ProjectView()
        projectView.delegate = self
        self.view = projectView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc private func showAddProjectOverlay() {
        let overlay = AddProjectOverlayView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.delegate = self

        overlay.onSave = { [weak self] name, color, shortId in
            guard let self = self else { return }

            let newProject = ProjectModel(
                id: UUID(),
                name: name,
                color: color,
                shortId: shortId,     
                startDate: Date(),
                tasks: []
            )

            NetworkManager.shared.postProject(newProject) { success in
                DispatchQueue.main.async {
                    if success {
                        self.projects.insert(newProject, at: 0)
                        overlay.removeFromSuperview()
                    } else {
                    }
                }
            }
        }


        overlay.onCancel = {
            overlay.removeFromSuperview()
        }

        view.addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            overlay.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            overlay.heightAnchor.constraint(equalToConstant: 300)
        ])
    }


    @objc private func showJoinProjectOverlay() {
        let joinOverlay = JoinProjectOverlayView()
        joinOverlay.translatesAutoresizingMaskIntoConstraints = false
        joinOverlay.delegate = self

        joinOverlay.onJoin = { [weak self] projectId in
            NetworkManager.shared.fetchProjectById(projectId) { project in
                DispatchQueue.main.async {
                    if let project = project {
                        self?.projects.insert(project, at: 0)
                        self?.projectView.updateProjects(self?.projects ?? [])
                        joinOverlay.removeFromSuperview()
                    } else {
                    }
                }
            }
        }



        joinOverlay.onCancel = {
            joinOverlay.removeFromSuperview()
        }

        view.addSubview(joinOverlay)
        NSLayoutConstraint.activate([
            joinOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            joinOverlay.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            joinOverlay.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            joinOverlay.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

// MARK: - ProjectViewDelegate

extension ProjectViewController: ProjectViewDelegate {
    func didSelectProject(_ project: ProjectModel) {
        let calendarVC = CalendarViewController(project: project)
        navigationController?.pushViewController(calendarVC, animated: true)
    }

    func didTapAddProject() {
        showAddProjectOverlay()
    }
    
    func didTapJoinButton() {
        showJoinProjectOverlay()
    }
    
    func didTapBackToAddProject() {
        showAddProjectOverlay()
    }

}
