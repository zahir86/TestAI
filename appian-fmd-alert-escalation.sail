/*
 * MOCKUP APPIAN - GENERAZIONE ALERT ED ESCALATION (Punto 5)
 * Sistema EMVS/NMVS - Gestione Anomalie FMD
 * Direttiva 2011/62/UE - Regolamento Delegato (UE) 2016/161
 */

a!localVariables(
  /* Lista Alert simulati */
  local!alerts: {
    a!map(
      id: "ALT-2024-001234",
      dataOra: today() - 1,
      livello: "L5",
      tipo: "FALSIFICAZIONE_SOSPETTA",
      descrizione: "UI non presente nel database NMVS",
      codiceProdotto: "08012345678901",
      numeroSeriale: "SN2024XYZ789012",
      lotto: "LOT2024-099",
      mah: "Pharma Company S.p.A.",
      farmacia: "Farmacia Centrale - Roma",
      stato: "APERTO",
      assegnatoA: "MAH Investigation Team"
    ),
    a!map(
      id: "ALT-2024-001233",
      dataOra: today() - 2,
      livello: "L3",
      tipo: "ATD_MANOMESSO",
      descrizione: "Dispositivo anti-manomissione compromesso",
      codiceProdotto: "08098765432101",
      numeroSeriale: "SN2024ABC456789",
      lotto: "LOT2024-045",
      mah: "BioMed Italia S.r.l.",
      farmacia: "Ospedale San Giovanni - Milano",
      stato: "IN_ANALISI",
      assegnatoA: "Quality Assurance"
    ),
    a!map(
      id: "ALT-2024-001232",
      dataOra: today() - 3,
      livello: "L2",
      tipo: "SCADENZA_ERRATA",
      descrizione: "Data scadenza non corrispondente",
      codiceProdotto: "08055544433322",
      numeroSeriale: "SN2024DEF123456",
      lotto: "LOT2024-078",
      mah: "Generic Pharma S.p.A.",
      farmacia: "Farmacia Ospedaliera - Napoli",
      stato: "RISOLTO",
      assegnatoA: "Data Management"
    )
  },

  /* Filtri */
  local!filtroLivello: null,
  local!filtroStato: null,
  local!filtroTipo: null,

  /* Alert selezionato per dettaglio */
  local!alertSelezionato: null,
  local!mostraDettaglio: false,

  /* Nuovo Alert */
  local!mostraNuovoAlert: false,
  local!nuovoAlert: a!map(
    tipo: "",
    livello: "",
    descrizione: "",
    codiceProdotto: "",
    numeroSeriale: "",
    lotto: ""
  ),

  /* Statistiche */
  local!totaleAperti: count(
    where(
      a!forEach(local!alerts, fv!item.stato = "APERTO"),
      true
    )
  ),
  local!totaleInAnalisi: count(
    where(
      a!forEach(local!alerts, fv!item.stato = "IN_ANALISI"),
      true
    )
  ),

  a!sectionLayout(
    label: "",
    contents: {
      /* ========== HEADER ========== */
      a!cardLayout(
        contents: {
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(
                        icon: "bell",
                        size: "LARGE",
                        color: "ACCENT"
                      ),
                      " ",
                      a!richTextItem(
                        text: "GENERAZIONE ALERT ED ESCALATION",
                        size: "LARGE",
                        style: "STRONG"
                      )
                    }
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Sistema EMVS/NMVS - Gestione Anomalie e Processo di Escalation",
                        size: "MEDIUM",
                        color: "SECONDARY"
                      )
                    }
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Operatore: ",
                        color: "SECONDARY"
                      ),
                      a!richTextItem(
                        text: loggedInUser(),
                        style: "STRONG"
                      )
                    },
                    align: "RIGHT"
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: text(now(), "dd/mm/yyyy HH:mm"),
                        color: "SECONDARY"
                      )
                    },
                    align: "RIGHT"
                  )
                },
                width: "NARROW"
              )
            }
          )
        },
        style: "ACCENT",
        padding: "STANDARD",
        marginBelow: "STANDARD"
      ),

      /* ========== KPI DASHBOARD ========== */
      a!columnsLayout(
        columns: {
          a!columnLayout(
            contents: {
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Alert Critici (L5)",
                        size: "SMALL",
                        color: "SECONDARY"
                      )
                    }
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "1",
                        size: "LARGE",
                        style: "STRONG",
                        color: "NEGATIVE"
                      )
                    }
                  )
                },
                style: "STANDARD",
                padding: "STANDARD"
              )
            }
          ),
          a!columnLayout(
            contents: {
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Alert Aperti",
                        size: "SMALL",
                        color: "SECONDARY"
                      )
                    }
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "1",
                        size: "LARGE",
                        style: "STRONG",
                        color: "NEGATIVE"
                      )
                    }
                  )
                },
                style: "STANDARD",
                padding: "STANDARD"
              )
            }
          ),
          a!columnLayout(
            contents: {
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "In Analisi",
                        size: "SMALL",
                        color: "SECONDARY"
                      )
                    }
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "1",
                        size: "LARGE",
                        style: "STRONG",
                        color: "WARNING"
                      )
                    }
                  )
                },
                style: "STANDARD",
                padding: "STANDARD"
              )
            }
          ),
          a!columnLayout(
            contents: {
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Risolti (Ultimi 7gg)",
                        size: "SMALL",
                        color: "SECONDARY"
                      )
                    }
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "1",
                        size: "LARGE",
                        style: "STRONG",
                        color: "POSITIVE"
                      )
                    }
                  )
                },
                style: "STANDARD",
                padding: "STANDARD"
              )
            }
          )
        },
        marginBelow: "STANDARD"
      ),

      /* ========== LEGENDA LIVELLI CRITICITA' ========== */
      a!cardLayout(
        contents: {
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextIcon(
                icon: "info-circle",
                color: "ACCENT"
              ),
              " ",
              a!richTextItem(
                text: "LIVELLI DI CRITICITÀ ALERT",
                style: "STRONG"
              )
            }
          ),
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "L1",
                        style: "STRONG",
                        color: "SECONDARY"
                      ),
                      " - Anomalia minore (dati incompleti)"
                    }
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "L2",
                        style: "STRONG",
                        color: "ACCENT"
                      ),
                      " - Discrepanza dati"
                    }
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "L3",
                        style: "STRONG",
                        color: "WARNING"
                      ),
                      " - ATD compromesso"
                    }
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "L4",
                        style: "STRONG",
                        color: "NEGATIVE"
                      ),
                      " - UI già decomm."
                    }
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "L5",
                        style: "STRONG",
                        color: "NEGATIVE"
                      ),
                      " - Sospetta falsificazione"
                    }
                  )
                }
              )
            }
          )
        },
        style: "STANDARD",
        padding: "STANDARD",
        marginBelow: "STANDARD"
      ),

      /* ========== FILTRI ========== */
      a!cardLayout(
        contents: {
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextIcon(
                icon: "filter",
                color: "ACCENT"
              ),
              " ",
              a!richTextItem(
                text: "FILTRI",
                style: "STRONG"
              )
            }
          ),
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!dropdownField(
                    label: "Livello Criticità",
                    labelPosition: "ABOVE",
                    placeholder: "Tutti i livelli",
                    choiceLabels: {"L1 - Minore", "L2 - Discrepanza", "L3 - ATD", "L4 - UI Decomm.", "L5 - Critico"},
                    choiceValues: {"L1", "L2", "L3", "L4", "L5"},
                    value: local!filtroLivello,
                    saveInto: local!filtroLivello
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!dropdownField(
                    label: "Stato",
                    labelPosition: "ABOVE",
                    placeholder: "Tutti gli stati",
                    choiceLabels: {"Aperto", "In Analisi", "In Escalation", "Risolto", "Chiuso"},
                    choiceValues: {"APERTO", "IN_ANALISI", "IN_ESCALATION", "RISOLTO", "CHIUSO"},
                    value: local!filtroStato,
                    saveInto: local!filtroStato
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!dropdownField(
                    label: "Tipo Anomalia",
                    labelPosition: "ABOVE",
                    placeholder: "Tutti i tipi",
                    choiceLabels: {
                      "Falsificazione Sospetta",
                      "ATD Manomesso",
                      "UI Già Decommissionato",
                      "Scadenza Errata",
                      "Lotto Non Corrispondente"
                    },
                    choiceValues: {
                      "FALSIFICAZIONE_SOSPETTA",
                      "ATD_MANOMESSO",
                      "UI_DECOMMISSIONATO",
                      "SCADENZA_ERRATA",
                      "LOTTO_NON_CORRISPONDENTE"
                    },
                    value: local!filtroTipo,
                    saveInto: local!filtroTipo
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!buttonArrayLayout(
                    buttons: {
                      a!buttonWidget(
                        label: "Applica",
                        icon: "search",
                        style: "SOLID"
                      ),
                      a!buttonWidget(
                        label: "Reset",
                        icon: "times",
                        style: "OUTLINE",
                        saveInto: {
                          a!save(local!filtroLivello, null),
                          a!save(local!filtroStato, null),
                          a!save(local!filtroTipo, null)
                        }
                      )
                    },
                    align: "END"
                  )
                },
                width: "NARROW"
              )
            },
            alignVertical: "BOTTOM"
          )
        },
        style: "STANDARD",
        padding: "STANDARD",
        marginBelow: "STANDARD"
      ),

      /* ========== LISTA ALERT ========== */
      a!cardLayout(
        contents: {
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextIcon(
                icon: "list",
                color: "ACCENT"
              ),
              " ",
              a!richTextItem(
                text: "ELENCO ALERT",
                style: "STRONG"
              ),
              " ",
              a!richTextItem(
                text: "(" & count(local!alerts) & " risultati)",
                color: "SECONDARY"
              )
            }
          ),
          a!gridLayout(
            label: "",
            labelPosition: "COLLAPSED",
            headerCells: {
              a!gridLayoutHeaderCell(label: "ID Alert"),
              a!gridLayoutHeaderCell(label: "Data/Ora"),
              a!gridLayoutHeaderCell(label: "Livello"),
              a!gridLayoutHeaderCell(label: "Tipo Anomalia"),
              a!gridLayoutHeaderCell(label: "MAH"),
              a!gridLayoutHeaderCell(label: "Stato"),
              a!gridLayoutHeaderCell(label: "Azioni")
            },
            rows: a!forEach(
              items: local!alerts,
              expression: a!gridRowLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: fv!item.id,
                        style: "STRONG",
                        link: a!dynamicLink(
                          saveInto: {
                            a!save(local!alertSelezionato, fv!item),
                            a!save(local!mostraDettaglio, true)
                          }
                        )
                      )
                    }
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: text(fv!item.dataOra, "dd/mm/yyyy")
                  ),
                  a!stampField(
                    labelPosition: "COLLAPSED",
                    text: fv!item.livello,
                    backgroundColor: if(
                      fv!item.livello = "L5",
                      "NEGATIVE",
                      if(
                        fv!item.livello = "L4",
                        "NEGATIVE",
                        if(
                          fv!item.livello = "L3",
                          "WARNING",
                          if(
                            fv!item.livello = "L2",
                            "ACCENT",
                            "SECONDARY"
                          )
                        )
                      )
                    )
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: substitute(fv!item.tipo, "_", " ")
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: fv!item.mah
                  ),
                  a!stampField(
                    labelPosition: "COLLAPSED",
                    text: substitute(fv!item.stato, "_", " "),
                    backgroundColor: if(
                      fv!item.stato = "APERTO",
                      "NEGATIVE",
                      if(
                        fv!item.stato = "IN_ANALISI",
                        "WARNING",
                        if(
                          fv!item.stato = "RISOLTO",
                          "POSITIVE",
                          "SECONDARY"
                        )
                      )
                    )
                  ),
                  a!buttonArrayLayout(
                    buttons: {
                      a!buttonWidget(
                        label: "",
                        icon: "eye",
                        style: "OUTLINE",
                        size: "SMALL",
                        saveInto: {
                          a!save(local!alertSelezionato, fv!item),
                          a!save(local!mostraDettaglio, true)
                        }
                      ),
                      a!buttonWidget(
                        label: "",
                        icon: "arrow-up",
                        style: "OUTLINE",
                        size: "SMALL",
                        disabled: fv!item.stato = "RISOLTO"
                      )
                    }
                  )
                }
              )
            ),
            selectionStyle: "ROW_HIGHLIGHT"
          )
        },
        style: "STANDARD",
        padding: "STANDARD",
        marginBelow: "STANDARD"
      ),

      /* ========== DETTAGLIO ALERT (POPUP) ========== */
      if(
        local!mostraDettaglio,
        a!cardLayout(
          contents: {
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextIcon(
                  icon: "exclamation-triangle",
                  size: "MEDIUM",
                  color: "NEGATIVE"
                ),
                " ",
                a!richTextItem(
                  text: "DETTAGLIO ALERT: " & local!alertSelezionato.id,
                  size: "MEDIUM",
                  style: "STRONG"
                )
              }
            ),
            a!columnsLayout(
              columns: {
                a!columnLayout(
                  contents: {
                    a!textField(
                      label: "ID Alert",
                      value: local!alertSelezionato.id,
                      readOnly: true
                    ),
                    a!textField(
                      label: "Data/Ora Generazione",
                      value: text(local!alertSelezionato.dataOra, "dd/mm/yyyy HH:mm:ss"),
                      readOnly: true
                    ),
                    a!textField(
                      label: "Livello Criticità",
                      value: local!alertSelezionato.livello,
                      readOnly: true
                    ),
                    a!textField(
                      label: "Tipo Anomalia",
                      value: substitute(local!alertSelezionato.tipo, "_", " "),
                      readOnly: true
                    )
                  }
                ),
                a!columnLayout(
                  contents: {
                    a!textField(
                      label: "Codice Prodotto (GTIN)",
                      value: local!alertSelezionato.codiceProdotto,
                      readOnly: true
                    ),
                    a!textField(
                      label: "Numero Seriale",
                      value: local!alertSelezionato.numeroSeriale,
                      readOnly: true
                    ),
                    a!textField(
                      label: "Lotto",
                      value: local!alertSelezionato.lotto,
                      readOnly: true
                    ),
                    a!textField(
                      label: "MAH",
                      value: local!alertSelezionato.mah,
                      readOnly: true
                    )
                  }
                ),
                a!columnLayout(
                  contents: {
                    a!textField(
                      label: "Farmacia/Ospedale",
                      value: local!alertSelezionato.farmacia,
                      readOnly: true
                    ),
                    a!textField(
                      label: "Stato Attuale",
                      value: substitute(local!alertSelezionato.stato, "_", " "),
                      readOnly: true
                    ),
                    a!textField(
                      label: "Assegnato A",
                      value: local!alertSelezionato.assegnatoA,
                      readOnly: true
                    ),
                    a!paragraphField(
                      label: "Descrizione",
                      value: local!alertSelezionato.descrizione,
                      readOnly: true,
                      height: "SHORT"
                    )
                  }
                )
              }
            ),

            /* Timeline Escalation */
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(
                  text: "TIMELINE ESCALATION",
                  style: "STRONG"
                )
              },
              marginAbove: "STANDARD"
            ),
            a!boxLayout(
              label: "",
              style: "STANDARD",
              contents: {
                a!forEach(
                  items: {
                    a!map(data: "Alert generato dal sistema NMVS", ora: "10:30", stato: "completato"),
                    a!map(data: "Notifica inviata a Farmacia", ora: "10:31", stato: "completato"),
                    a!map(data: "Escalation L3 -> L5", ora: "10:45", stato: "completato"),
                    a!map(data: "Notifica inviata a MAH", ora: "10:46", stato: "completato"),
                    a!map(data: "In attesa analisi MAH", ora: "11:00", stato: "in_corso")
                  },
                  expression: a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(
                        icon: if(fv!item.stato = "completato", "check-circle", "clock-o"),
                        color: if(fv!item.stato = "completato", "POSITIVE", "WARNING")
                      ),
                      " ",
                      a!richTextItem(
                        text: fv!item.ora & " - ",
                        style: "STRONG"
                      ),
                      a!richTextItem(
                        text: fv!item.data
                      )
                    },
                    marginBelow: "STANDARD"
                  )
                )
              }
            ),

            a!buttonArrayLayout(
              buttons: {
                a!buttonWidget(
                  label: "Escalation",
                  icon: "arrow-up",
                  style: "SOLID"
                ),
                a!buttonWidget(
                  label: "Assegna",
                  icon: "user",
                  style: "OUTLINE"
                ),
                a!buttonWidget(
                  label: "Risolvi",
                  icon: "check",
                  style: "OUTLINE"
                ),
                a!buttonWidget(
                  label: "Chiudi Dettaglio",
                  icon: "times",
                  style: "OUTLINE",
                  saveInto: {
                    a!save(local!mostraDettaglio, false),
                    a!save(local!alertSelezionato, null)
                  }
                )
              },
              align: "END",
              marginAbove: "STANDARD"
            )
          },
          style: "ERROR",
          padding: "STANDARD",
          marginBelow: "STANDARD"
        ),
        {}
      ),

      /* ========== PROCESSO ESCALATION ========== */
      a!cardLayout(
        contents: {
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextIcon(
                icon: "sitemap",
                color: "ACCENT"
              ),
              " ",
              a!richTextItem(
                text: "PROCESSO DI ESCALATION",
                style: "STRONG"
              )
            }
          ),
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextItem(
                text: "Il sistema EMVS/NMVS attiva automaticamente il processo di escalation in base alla criticità rilevata:",
                color: "SECONDARY"
              )
            },
            marginBelow: "STANDARD"
          ),
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!boxLayout(
                    label: "L1-L2: Farmacia",
                    style: "STANDARD",
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextBulletedList(
                            items: {
                              "Verifica locale",
                              "Correzione dati",
                              "Tempo max: 24h"
                            }
                          )
                        }
                      )
                    }
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: a!richTextIcon(icon: "arrow-right", size: "LARGE"),
                    align: "CENTER"
                  )
                },
                width: "EXTRA_NARROW"
              ),
              a!columnLayout(
                contents: {
                  a!boxLayout(
                    label: "L3-L4: MAH",
                    style: "WARN",
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextBulletedList(
                            items: {
                              "Analisi approfondita",
                              "Verifica supply chain",
                              "Tempo max: 48h"
                            }
                          )
                        }
                      )
                    }
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: a!richTextIcon(icon: "arrow-right", size: "LARGE"),
                    align: "CENTER"
                  )
                },
                width: "EXTRA_NARROW"
              ),
              a!columnLayout(
                contents: {
                  a!boxLayout(
                    label: "L5: Autorità",
                    style: "ERROR",
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextBulletedList(
                            items: {
                              "Notifica AIFA",
                              "Blocco lotto",
                              "Indagine ufficiale"
                            }
                          )
                        }
                      )
                    }
                  )
                }
              )
            },
            alignVertical: "MIDDLE"
          )
        },
        style: "STANDARD",
        padding: "STANDARD",
        marginBelow: "STANDARD"
      )
    }
  )
)
