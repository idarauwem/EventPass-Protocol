;; EventPass Protocol - Decentralized event ticketing and access management
(define-non-fungible-token event-pass uint)

;; Storage
(define-map event-database uint {organizer: principal, event-title: (string-utf8 64), venue-details: (string-utf8 256), access-code: (string-utf8 256), ticket-price: uint})
(define-data-var pass-counter uint u0)

;; Error codes
(define-constant err-unauthorized-organizer (err u400))
(define-constant err-event-not-found (err u401))
(define-constant err-payment-insufficient (err u402))
(define-constant err-empty-event-title (err u403))
(define-constant err-empty-venue-details (err u404))
(define-constant err-invalid-access-code (err u405))
(define-constant err-invalid-ticket-price (err u406))
(define-constant err-invalid-pass-id (err u407))

;; Create a new event with ticketing
(define-public (create-event (event-title (string-utf8 64)) (venue-details (string-utf8 256)) (access-code (string-utf8 256)) (ticket-price uint))
  (begin
    ;; Validate event information
    (asserts! (> (len event-title) u0) err-empty-event-title)
    (asserts! (> (len venue-details) u0) err-empty-venue-details)
    (asserts! (> (len access-code) u0) err-invalid-access-code)
    (asserts! (> ticket-price u0) err-invalid-ticket-price)
    
    (let
      ((pass-id (var-get pass-counter))
       (organizer tx-sender))
      
      ;; Mint event pass NFT
      (try! (nft-mint? event-pass pass-id organizer))
      
      ;; Store event information
      (map-set event-database pass-id {organizer: organizer, event-title: event-title, venue-details: venue-details, access-code: access-code, ticket-price: ticket-price})
      
      ;; Increment pass counter
      (var-set pass-counter (+ pass-id u1))
      
      (ok pass-id))))

;; Purchase event ticket
(define-public (purchase-ticket (pass-id uint))
  (begin
    ;; Validate pass ID
    (asserts! (< pass-id (var-get pass-counter)) err-invalid-pass-id)
    
    (let
      ((event-info (unwrap! (map-get? event-database pass-id) err-event-not-found))
       (price (get ticket-price event-info))
       (organizer (get organizer event-info))
       (current-owner (unwrap! (nft-get-owner? event-pass pass-id) err-event-not-found)))
      
      ;; Check attendee has enough funds
      (asserts! (>= (stx-get-balance tx-sender) price) err-payment-insufficient)
      
      ;; Transfer payment to organizer
      (try! (stx-transfer? price tx-sender organizer))
      
      ;; Transfer event pass to attendee
      (try! (nft-transfer? event-pass pass-id current-owner tx-sender))
      
      (ok true))))

;; Get event information
(define-read-only (get-event-info (pass-id uint))
  (map-get? event-database pass-id))

;; Verify event attendance
(define-read-only (has-event-access (pass-id uint) (attendee principal))
  (is-eq (some attendee) (nft-get-owner? event-pass pass-id)))

;; Get pass holder
(define-read-only (get-pass-holder (pass-id uint))
  (nft-get-owner? event-pass pass-id))
