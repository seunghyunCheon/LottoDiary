//
//  CoreDataLottoEntityPersistenceService.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/16.
//

import Foundation
import Combine

fileprivate enum CoreDataLottoEntityPersistenceServiceError: LocalizedError {
    case failedToInitializeCoreDataContainer
    case failedToFetchLottoEntity
    case failedToFetchDistinctYear

    var errorDescription: String? {
        switch self {
        case .failedToInitializeCoreDataContainer:
            return "CoreDataContainer 초기화에 실패했습니다."
        case .failedToFetchDistinctYear:
            return "LottoEntity의 년도 데이터 불러오기에 실패했습니다."
        case .failedToFetchLottoEntity:
            return "id로 LottoEntity를 불러오기에 실패했습니다."
        }
    }
}

final class CoreDataLottoEntityPersistenceService: CoreDataLottoEntityPersistenceServiceProtocol {
    
    private let coreDataPersistenceService: CoreDataPersistenceServiceProtocol

    init(coreDataPersistenceService: CoreDataPersistenceServiceProtocol) {
        self.coreDataPersistenceService = coreDataPersistenceService
    }

    func fetchLottoEntitiesWithoutWinningAmount() -> AnyPublisher<[Lotto], Error> {
        guard let context = coreDataPersistenceService.backgroundContext else {
            return Fail(error: CoreDataLottoEntityPersistenceServiceError.failedToInitializeCoreDataContainer)
                .eraseToAnyPublisher()
        }

        return Future { promise in
            context.perform {
                let fetchRequest = LottoEntity.fetchRequest()
                let predicate = NSPredicate(format: "winningAmount == -1")
                fetchRequest.predicate = predicate
                do {
                    let fetchResult = try context.fetch(fetchRequest)
                    promise(.success(fetchResult.map {
                        $0.convertToDomain() }))

                    #if DEBUG
                    print(
                        """
                        [✅][CoreDataLottoEntityPersistenceService.swift] -> CoreData fetch 성공 :
                            당첨금액이 -1인 로또 데이터 조회 성공
                        """
                    )

                    #endif
                } catch {
                    promise(.failure(CoreDataLottoEntityPersistenceServiceError.failedToFetchLottoEntity))

                    #if DEBUG
                    print(
                        """
                        [🆘][CoreDataLottoEntityPersistenceService.swift] -> CoreData fetch 실패 :
                            당첨금액이 -1인 로또 데이터 조회 실패
                        """
                    )

                    #endif
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchLottoEntities(with startDate: Date, and endDate: Date) -> AnyPublisher<[Lotto], Error> {
        guard let context = coreDataPersistenceService.backgroundContext else {
            return Fail(error: CoreDataLottoEntityPersistenceServiceError.failedToInitializeCoreDataContainer).eraseToAnyPublisher()
        }

        return Future { promise in
            context.perform {
                let fetchRequest = LottoEntity.fetchRequest()
                let predicate = NSPredicate(format: "date >= %@ && date <= %@", startDate as CVarArg, endDate as CVarArg)
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                do {
                    let fetchResult = try context.fetch(fetchRequest)
                    promise(.success(fetchResult.map { $0.convertToDomain() }))

                    #if DEBUG
                    print(
                        """
                        [✅][CoreDataLottoEntityPersistenceService.swift] -> CoreData fetch 성공 :
                            \(startDate) ~ \(endDate) 간의 로또 데이터 조회 성공
                        """
                    )

                    #endif
                } catch {
                    promise(.failure(CoreDataLottoEntityPersistenceServiceError.failedToFetchLottoEntity))

                    #if DEBUG
                    print(
                        """
                        [🆘][CoreDataLottoEntityPersistenceService.swift] -> CoreData fetch 실패 :
                            \(startDate) ~ \(endDate) 간의 로또 데이터 조회 성공
                        """
                    )

                    #endif
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func fetchDistinctYear() -> AnyPublisher<Set<Int>, Error> {
        guard let context = coreDataPersistenceService.backgroundContext else {
            return Fail(error: CoreDataLottoEntityPersistenceServiceError.failedToInitializeCoreDataContainer).eraseToAnyPublisher()
        }

        return Future { promise in
            context.perform {
                do {
                    let fetchRequest = LottoEntity.fetchRequest()
                    let fetchResult = try context.fetch(fetchRequest)

                    if fetchResult.isEmpty {
                        promise(.success([Date.today.year]))
                    }
                    let years = Set(fetchResult.compactMap { lottoEntity in
                        let date = lottoEntity.value(forKey: "date") as? Date
                        return date?.year
                    })
                    promise(.success(years))
                } catch {
                    promise(.failure(CoreDataLottoEntityPersistenceServiceError.failedToFetchDistinctYear))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func saveLottoEntity(_ lotto: Lotto) -> AnyPublisher<Lotto, Error> {
        guard let context = coreDataPersistenceService.backgroundContext else {
            return Fail(error: CoreDataLottoEntityPersistenceServiceError.failedToInitializeCoreDataContainer).eraseToAnyPublisher()
        }
        
        return Future { promise in
            context.perform {
                do {
                    let lottoEntity = LottoEntity(context: context)
                    lottoEntity.update(lotto: lotto)
                    try context.save()

                    promise(.success(lottoEntity.convertToDomain()))

                    #if DEBUG
                    print(
                        """
                        [✅][CoreDataLottoEntityPersistenceService.swift] -> CoreData 저장 성공 :
                            새로운 로또 인스턴스 저장
                            \(lotto)
                        """
                    )

                    #endif
                } catch {
                    promise(.failure(CoreDataLottoEntityPersistenceServiceError.failedToFetchLottoEntity))

                    #if DEBUG
                    print(
                        """
                        [🆘][CoreDataLottoEntityPersistenceService.swift] -> CoreData 저장 실패 :
                            새로운 로또 인스턴스 저장 실패

                        """
                    )

                    #endif
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func updateWinningAmount(_ lotto: Lotto, amount: Int) {
        guard let context = coreDataPersistenceService.backgroundContext else {
            print(CoreDataLottoEntityPersistenceServiceError.failedToInitializeCoreDataContainer)
            return
        }

        let fetchRequest = LottoEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", lotto.id as CVarArg)
        fetchRequest.predicate = predicate
        do {
            guard let fetchResult = try context.fetch(fetchRequest).first else { return }
            fetchResult.winningAmount = amount
            try context.save()

            #if DEBUG
            print(
                """
                [✅][CoreDataLottoEntityPersistenceService.swift] -> CoreData 업데이트 성공 :
                    기존의 로또 데이터에서 당첨 금액 업데이트
                    \(fetchResult)
                """
            )

            #endif
        } catch {
            print(CoreDataLottoEntityPersistenceServiceError.failedToFetchLottoEntity)

            #if DEBUG
            print(
                """
                [🆘][CoreDataLottoEntityPersistenceService.swift] -> CoreData 업데이트 실패 :
                    기존 로또 데이터에서 당첨 금액 업데이트

                """
            )

            #endif
        }
    }
}
