#!/usr/bin/env bb
; Advent of Code 2022 / Day 13 / Gold
(declare cmp-packet)

(defn cmp-vec [l r]
  (cond
    (= 0 (count l) (count r)) 0
    (= 0 (count l))           -1
    (= 0 (count r))           1
    :else (let [res (cmp-packet (first l) (first r))]
            (if (= 0 res)
              (cmp-vec (subvec l 1) (subvec r 1))
              res))))

(defn cmp-packet [l r]
  (cond
    (= Long (type l) (type r))      (compare l r)
    (= (type []) (type l) (type r)) (cmp-vec l r)
    (= Long (type l))               (cmp-vec [l] r)
    :else                           (cmp-vec l [r])))

(as->(slurp "i13.txt") $
     (str/split-lines $)
     (remove str/blank? $)
     (mapv edn/read-string $)
     (into [[[2]] [[6]]] $)
     (sort cmp-packet $)
     (vec $)
     (* (inc (.indexOf $ [[2]]))
        (inc (.indexOf $ [[6]])))
     (pprint $))
