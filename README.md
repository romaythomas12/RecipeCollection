# RecipeCollection App

A SwiftUI iOS app demonstrating a modular, testable architecture for displaying recipes with remote API fetching, local caching (CoreDB), and Swift Concurrency support.

---

## Table of Contents

1. [Overview](#overview)
2. [Modules](#modules)
3. [Unit Tests](#unit-tests)
4. [Setup](#setup)
5. [Usage](#usage)

---

## Overview

**RecipeCollection** fetches recipes from the Tasty API, caches them locally using Realm, and presents them in SwiftUI. Users can view details, mark favourites, and the app maintains thread-safe data access using Swift `actor`s. The UI is modular and leverages reusable components from **CoreUI**.

---

## Architecture Diagram

```
+------------------------ RecipeCollectionApp ------------------------+
| Entry Point: @main                                                 |
| - Creates RecipesFactory                                           |
| - Injects RecipesRepository (remote + local)                      |
+------------------------+-------------------------------------------+
                         |
                         v
+------------------------ Core Module -------------------------------+
| - Domain Models: Recipe, IngredientItem, InstructionItem           |
| - Protocols: RecipesRepositoryProtocol, RecipesRemoteServiceProtocol |
| - ViewModels: RecipesListViewModel, RecipeDetailViewModel         |
| - RecipesFactory: constructs SwiftUI Views                        |
+------------------------+-------------------------------------------+
                         |
                         v
+------------------------ CoreDB Module -----------------------------+
| - Persisted Models: PersistedRecipe, PersistedIngredientItem       |
| - Realm Entities: RealmRecipe, RealmIngredient, RealmInstruction  |
| - Local Service Actor: RecipesLocalService                        |
| - Mapping: Persisted <-> Domain                                   |
+------------------------+-------------------------------------------+
                         |
                         v
+------------------------ CoreUI Module -----------------------------+
| - Reusable SwiftUI components:                                      |
|   - AsyncThumbnail                                                  |
|   - GenericListRow                                                  |
|   - ActionButton                                                    |
| - Provides accessibility labels, corner radius, placeholders       |
| - Used across RecipesFeature views                                  |
+------------------------+-------------------------------------------+
                         |
                         v
+------------------------ RecipesFeature / UI -----------------------+
| - SwiftUI Views: RecipesListView, RecipeDetailView                |
| - Integrates CoreUI components for UI                            |
| - Navigation: NavigationStack + navigationDestination             |
+------------------------+-------------------------------------------+
                         |
                         v
+------------------------ Remote API Layer --------------------------+
| - RecipesRemoteService Actor                                       |
| - RequestBuilder (configurable host, apiKey, headers, HTTP method)|
| - Fetches data asynchronously                                      |
| - Fallback: CoreDB local cache                                     |
+--------------------------------------------------------------------+


```

## Modules

- **Core (SPM)**  
  Handles domain models, protocols, and ViewModels.

- **CoreDB (SPM)**  
  Handles Realm-based persistence and mapping between persisted and domain models.

- **CoreUI (SPM)**  
  Contains reusable SwiftUI components such as `AsyncThumbnail`, `GenericListRow`, and `ActionButton`, including accessibility support.

- **RecipesFeature (SPM)**  
  SwiftUI views, integrates CoreUI components, and provides factories for constructing views.

---

## Unit Tests

- **CoreTests** → Tests domain logic and repository interactions.  
- **CoreDBTests** → Tests Realm persistence, mapping, and local caching.  
- **CoreUITests** → Tests reusable SwiftUI components and accessibility.  
- **RecipesFeatureTests** → Tests SwiftUI ViewModels, UI state, and interactions.  

> All tests are fully **Swift 6 concurrency aware**, using `async`/`await` and `actor`s.

---

## Setup


1. Clone the repository.  
2. Open the `.xcodeproj` 
3. Ensure SPM packages are resolved (e.g., RealmSwift).  
4. Set the API key in `RecipeCollectionApp.swift`:

```swift
@main
struct RecipeCollectionApp: App {
    static let key: String = "<YOUR_API_KEY>"
    ...
}
```
5. Build and run on iOS 18+ simulators or devices.
---

## Usage
- Build and run on iOS 18+ simulators or devices.
- Launch the app to see a list of recipes.
- Tap a recipe to view details.
- Tap the “Add to favourites” / “Remove from favourites” button to mark recipes.
- Favourites are highlighted in the main list and persisted locally.

---
