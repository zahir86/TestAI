/*
 * MOCKUP APPIAN - IMMISSIONE IN COMMERCIO (Punto 4)
 * Sistema di verifica FMD per Farmacia/Ospedale
 * Direttiva 2011/62/UE - Regolamento Delegato (UE) 2016/161
 */

a!localVariables(
  /* Variabili di stato */
  local!dataMatrixCode: "",
  local!scanCompleted: false,
  local!verificationInProgress: false,
  local!verificationCompleted: false,
  local!decommissioningCompleted: false,

  /* Dati prodotto estratti dal DataMatrix */
  local!productData: a!map(
    codiceProdotto: "",
    numeroSeriale: "",
    lotto: "",
    dataScadenza: "",
    nomeCommerciale: "",
    principioAttivo: "",
    dosaggio: "",
    formaFarmaceutica: "",
    mah: ""
  ),

  /* Risultati verifiche */
  local!nmvsStatus: "", /* "AUTENTICO", "SOSPETTO", "ERRORE" */
  local!atdStatus: "", /* "INTEGRO", "MANOMESSO", "NON_VERIFICABILE" */
  local!nmvsMessage: "",
  local!atdMessage: "",

  /* Dati operatore */
  local!operatore: loggedInUser(),
  local!dataOra: now(),
  local!sede: "Farmacia/Ospedale",
  local!tipoOperazione: "DISPENSAZIONE",

  /* Note e commenti */
  local!note: "",

  a!headerContentLayout(
      header: {
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
                          icon: "pills",
                          size: "LARGE",
                          color: "ACCENT"
                        ),
                        " ",
                        a!richTextItem(
                          text: "IMMISSIONE IN COMMERCIO",
                          size: "LARGE",
                          style: "STRONG"
                        )
                      }
                    ),
                    a!richTextDisplayField(
                      labelPosition: "COLLAPSED",
                      value: {
                        a!richTextItem(
                          text: "Sistema di Verifica FMD - Farmacia/Ospedale",
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
                          text: local!operatore,
                          style: "STRONG"
                        )
                      },
                      align: "RIGHT"
                    ),
                    a!richTextDisplayField(
                      labelPosition: "COLLAPSED",
                      value: {
                        a!richTextItem(
                          text: text(local!dataOra, "dd/mm/yyyy HH:mm"),
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
        )
      },
      contents: {
        a!sectionLayout(
          label: "",
          contents: {
            /* ========== SEZIONE 1: SCANSIONE DATAMATRIX ========== */
            a!cardLayout(
              contents: {
                a!richTextDisplayField(
                  labelPosition: "COLLAPSED",
                  value: {
                    a!richTextIcon(
                      icon: "qrcode",
                      size: "MEDIUM",
                      color: "ACCENT"
                    ),
                    " ",
                    a!richTextItem(
                      text: "1. SCANSIONE DATAMATRIX",
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
                          label: "Codice DataMatrix (2D)",
                          labelPosition: "ABOVE",
                          placeholder: "Scansiona o inserisci il codice DataMatrix...",
                          value: local!dataMatrixCode,
                          saveInto: local!dataMatrixCode,
                          refreshAfter: "UNFOCUS",
                          characterLimit: 100,
                          required: true,
                          disabled: local!scanCompleted
                        )
                      },
                      width: "WIDE"
                    ),
                    a!columnLayout(
                      contents: {
                        a!buttonArrayLayout(
                          buttons: {
                            a!buttonWidget(
                              label: "Scansiona",
                              icon: "barcode",
                              style: "SOLID",
                              disabled: or(
                                len(local!dataMatrixCode) = 0,
                                local!scanCompleted
                              ),
                              saveInto: {
                                a!save(local!scanCompleted, true),
                                /* Simulazione parsing DataMatrix */
                                a!save(
                                  local!productData,
                                  a!map(
                                    codiceProdotto: "08012345678901",
                                    numeroSeriale: "SN2024ABC123456",
                                    lotto: "LOT2024-001",
                                    dataScadenza: "31/12/2026",
                                    nomeCommerciale: "Farmaco Esempio 500mg",
                                    principioAttivo: "Principio Attivo XYZ",
                                    dosaggio: "500 mg",
                                    formaFarmaceutica: "Compresse rivestite",
                                    mah: "Pharma Company S.p.A."
                                  )
                                )
                              }
                            ),
                            a!buttonWidget(
                              label: "Reset",
                              icon: "refresh",
                              style: "OUTLINE",
                              saveInto: {
                                a!save(local!dataMatrixCode, ""),
                                a!save(local!scanCompleted, false),
                                a!save(local!verificationInProgress, false),
                                a!save(local!verificationCompleted, false),
                                a!save(local!decommissioningCompleted, false),
                                a!save(local!nmvsStatus, ""),
                                a!save(local!atdStatus, ""),
                                a!save(local!nmvsMessage, ""),
                                a!save(local!atdMessage, ""),
                                a!save(
                                  local!productData,
                                  a!map(
                                    codiceProdotto: "",
                                    numeroSeriale: "",
                                    lotto: "",
                                    dataScadenza: "",
                                    nomeCommerciale: "",
                                    principioAttivo: "",
                                    dosaggio: "",
                                    formaFarmaceutica: "",
                                    mah: ""
                                  )
                                )
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
                ),

                /* Dati Prodotto Estratti */
                if(
                  local!scanCompleted,
                  a!boxLayout(
                    label: "Dati Prodotto Identificato",
                    style: "INFO",
                    contents: {
                      a!columnsLayout(
                        columns: {
                          a!columnLayout(
                            contents: {
                              a!textField(
                                label: "Codice Prodotto (GTIN)",
                                value: local!productData.codiceProdotto,
                                readOnly: true
                              ),
                              a!textField(
                                label: "Numero Seriale",
                                value: local!productData.numeroSeriale,
                                readOnly: true
                              ),
                              a!textField(
                                label: "Lotto",
                                value: local!productData.lotto,
                                readOnly: true
                              )
                            }
                          ),
                          a!columnLayout(
                            contents: {
                              a!textField(
                                label: "Data Scadenza",
                                value: local!productData.dataScadenza,
                                readOnly: true
                              ),
                              a!textField(
                                label: "Nome Commerciale",
                                value: local!productData.nomeCommerciale,
                                readOnly: true
                              ),
                              a!textField(
                                label: "MAH (Titolare AIC)",
                                value: local!productData.mah,
                                readOnly: true
                              )
                            }
                          ),
                          a!columnLayout(
                            contents: {
                              a!textField(
                                label: "Principio Attivo",
                                value: local!productData.principioAttivo,
                                readOnly: true
                              ),
                              a!textField(
                                label: "Dosaggio",
                                value: local!productData.dosaggio,
                                readOnly: true
                              ),
                              a!textField(
                                label: "Forma Farmaceutica",
                                value: local!productData.formaFarmaceutica,
                                readOnly: true
                              )
                            }
                          )
                        }
                      )
                    },
                    marginAbove: "STANDARD"
                  ),
                  {}
                )
              },
              style: "STANDARD",
              padding: "STANDARD",
              marginBelow: "STANDARD"
            ),

            /* ========== SEZIONE 2: VERIFICA AUTENTICITA' NMVS ========== */
            if(
              local!scanCompleted,
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(
                        icon: "shield",
                        size: "MEDIUM",
                        color: "ACCENT"
                      ),
                      " ",
                      a!richTextItem(
                        text: "2. VERIFICA AUTENTICITÀ - INTERROGAZIONE NMVS",
                        size: "MEDIUM",
                        style: "STRONG"
                      )
                    }
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Verifica dell'autenticità del farmaco tramite interrogazione del National Medicines Verification System (NMVS)",
                        color: "SECONDARY",
                        size: "SMALL"
                      )
                    },
                    marginBelow: "STANDARD"
                  ),
                  a!columnsLayout(
                    columns: {
                      a!columnLayout(
                        contents: {
                          a!buttonArrayLayout(
                            buttons: {
                              a!buttonWidget(
                                label: "Verifica NMVS",
                                icon: "search",
                                style: "SOLID",
                                disabled: or(
                                  local!verificationCompleted,
                                  local!verificationInProgress
                                ),
                                saveInto: {
                                  a!save(local!verificationInProgress, true),
                                  /* Simulazione chiamata NMVS - risultato positivo */
                                  a!save(local!nmvsStatus, "AUTENTICO"),
                                  a!save(
                                    local!nmvsMessage,
                                    "Prodotto verificato con successo. UI presente nel database NMVS. Stato: ATTIVO"
                                  ),
                                  a!save(local!verificationInProgress, false)
                                }
                              )
                            }
                          )
                        },
                        width: "NARROW"
                      ),
                      a!columnLayout(
                        contents: {
                          /* Stato Verifica NMVS */
                          if(
                            len(local!nmvsStatus) > 0,
                            {
                              a!stampField(
                                labelPosition: "COLLAPSED",
                                icon: if(
                                  local!nmvsStatus = "AUTENTICO",
                                  "check-circle",
                                  if(
                                    local!nmvsStatus = "SOSPETTO",
                                    "exclamation-triangle",
                                    "times-circle"
                                  )
                                ),
                                text: local!nmvsStatus,
                                backgroundColor: if(
                                  local!nmvsStatus = "AUTENTICO",
                                  "POSITIVE",
                                  if(
                                    local!nmvsStatus = "SOSPETTO",
                                    "WARNING",
                                    "NEGATIVE"
                                  )
                                )
                              ),
                              a!richTextDisplayField(
                                labelPosition: "COLLAPSED",
                                value: {
                                  a!richTextItem(
                                    text: local!nmvsMessage,
                                    size: "SMALL"
                                  )
                                },
                                marginAbove: "STANDARD"
                              )
                            },
                            {}
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
              ),
              {}
            ),

            /* ========== SEZIONE 3: CONTROLLO INTEGRITA' ATD ========== */
            if(
              and(local!scanCompleted, len(local!nmvsStatus) > 0),
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(
                        icon: "lock",
                        size: "MEDIUM",
                        color: "ACCENT"
                      ),
                      " ",
                      a!richTextItem(
                        text: "3. CONTROLLO INTEGRITÀ ATD (Anti-Tampering Device)",
                        size: "MEDIUM",
                        style: "STRONG"
                      )
                    }
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Verifica visiva dell'integrità del dispositivo anti-manomissione sulla confezione",
                        color: "SECONDARY",
                        size: "SMALL"
                      )
                    },
                    marginBelow: "STANDARD"
                  ),
                  a!columnsLayout(
                    columns: {
                      a!columnLayout(
                        contents: {
                          a!radioButtonField(
                            label: "Stato ATD",
                            labelPosition: "ABOVE",
                            choiceLabels: {
                              "Integro - Nessun segno di manomissione",
                              "Manomesso - Segni evidenti di apertura/alterazione",
                              "Non verificabile - Impossibile determinare lo stato"
                            },
                            choiceValues: {"INTEGRO", "MANOMESSO", "NON_VERIFICABILE"},
                            value: local!atdStatus,
                            saveInto: {
                              local!atdStatus,
                              a!save(
                                local!atdMessage,
                                if(
                                  save!value = "INTEGRO",
                                  "Dispositivo anti-manomissione verificato. Confezione integra.",
                                  if(
                                    save!value = "MANOMESSO",
                                    "ATTENZIONE: Rilevati segni di manomissione. Procedere con segnalazione.",
                                    "Stato ATD non determinabile. Richiedere verifica aggiuntiva."
                                  )
                                )
                              )
                            },
                            disabled: local!verificationCompleted
                          )
                        }
                      ),
                      a!columnLayout(
                        contents: {
                          /* Stato ATD */
                          if(
                            len(local!atdStatus) > 0,
                            {
                              a!stampField(
                                labelPosition: "COLLAPSED",
                                icon: if(
                                  local!atdStatus = "INTEGRO",
                                  "check-circle",
                                  if(
                                    local!atdStatus = "MANOMESSO",
                                    "times-circle",
                                    "question-circle"
                                  )
                                ),
                                text: local!atdStatus,
                                backgroundColor: if(
                                  local!atdStatus = "INTEGRO",
                                  "POSITIVE",
                                  if(
                                    local!atdStatus = "MANOMESSO",
                                    "NEGATIVE",
                                    "WARNING"
                                  )
                                )
                              ),
                              a!richTextDisplayField(
                                labelPosition: "COLLAPSED",
                                value: {
                                  a!richTextItem(
                                    text: local!atdMessage,
                                    size: "SMALL"
                                  )
                                },
                                marginAbove: "STANDARD"
                              )
                            },
                            {}
                          )
                        },
                        width: "NARROW_PLUS"
                      )
                    }
                  )
                },
                style: "STANDARD",
                padding: "STANDARD",
                marginBelow: "STANDARD"
              ),
              {}
            ),

            /* ========== SEZIONE 4: DECOMMISSIONING UI ========== */
            if(
              and(
                local!scanCompleted,
                local!nmvsStatus = "AUTENTICO",
                local!atdStatus = "INTEGRO"
              ),
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(
                        icon: "check-square",
                        size: "MEDIUM",
                        color: "ACCENT"
                      ),
                      " ",
                      a!richTextItem(
                        text: "4. DECOMMISSIONING IDENTIFICATIVO UNIVOCO (UI)",
                        size: "MEDIUM",
                        style: "STRONG"
                      )
                    }
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Disattivazione dell'Identificativo Univoco nel sistema NMVS per completare il processo di dispensazione",
                        color: "SECONDARY",
                        size: "SMALL"
                      )
                    },
                    marginBelow: "STANDARD"
                  ),
                  a!columnsLayout(
                    columns: {
                      a!columnLayout(
                        contents: {
                          a!dropdownField(
                            label: "Tipo Operazione",
                            labelPosition: "ABOVE",
                            choiceLabels: {
                              "Dispensazione al paziente",
                              "Somministrazione in struttura",
                              "Fornitura ad altra struttura sanitaria",
                              "Restituzione/Reso"
                            },
                            choiceValues: {
                              "DISPENSAZIONE",
                              "SOMMINISTRAZIONE",
                              "FORNITURA",
                              "RESO"
                            },
                            value: local!tipoOperazione,
                            saveInto: local!tipoOperazione,
                            disabled: local!decommissioningCompleted
                          )
                        }
                      ),
                      a!columnLayout(
                        contents: {
                          a!paragraphField(
                            label: "Note (opzionale)",
                            labelPosition: "ABOVE",
                            placeholder: "Inserire eventuali note...",
                            value: local!note,
                            saveInto: local!note,
                            height: "SHORT",
                            disabled: local!decommissioningCompleted
                          )
                        }
                      )
                    }
                  ),
                  a!buttonArrayLayout(
                    buttons: {
                      a!buttonWidget(
                        label: "Esegui Decommissioning",
                        icon: "check",
                        style: "SOLID",
                        disabled: local!decommissioningCompleted,
                        saveInto: {
                          a!save(local!decommissioningCompleted, true),
                          a!save(local!verificationCompleted, true)
                        },
                        confirmHeader: "Conferma Decommissioning",
                        confirmMessage: "Stai per disattivare l'Identificativo Univoco. Questa operazione è irreversibile. Continuare?",
                        confirmButtonLabel: "Conferma",
                        cancelButtonLabel: "Annulla"
                      )
                    },
                    align: "END",
                    marginAbove: "STANDARD"
                  ),

                  /* Conferma Decommissioning */
                  if(
                    local!decommissioningCompleted,
                    a!boxLayout(
                      label: "",
                      style: "SUCCESS",
                      contents: {
                        a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          value: {
                            a!richTextIcon(
                              icon: "check-circle",
                              size: "LARGE",
                              color: "POSITIVE"
                            ),
                            " ",
                            a!richTextItem(
                              text: "DECOMMISSIONING COMPLETATO CON SUCCESSO",
                              size: "MEDIUM",
                              style: "STRONG",
                              color: "POSITIVE"
                            )
                          }
                        ),
                        a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          value: {
                            a!richTextItem(
                              text: "L'Identificativo Univoco è stato disattivato nel sistema NMVS. Il farmaco può essere dispensato/somministrato.",
                              size: "SMALL"
                            )
                          }
                        ),
                        a!columnsLayout(
                          columns: {
                            a!columnLayout(
                              contents: {
                                a!textField(
                                  label: "ID Transazione",
                                  value: "TRX-2024-" & text(rand() * 1000000, "000000"),
                                  readOnly: true
                                )
                              }
                            ),
                            a!columnLayout(
                              contents: {
                                a!textField(
                                  label: "Data/Ora Operazione",
                                  value: text(now(), "dd/mm/yyyy HH:mm:ss"),
                                  readOnly: true
                                )
                              }
                            ),
                            a!columnLayout(
                              contents: {
                                a!textField(
                                  label: "Operatore",
                                  value: local!operatore,
                                  readOnly: true
                                )
                              }
                            )
                          }
                        )
                      },
                      marginAbove: "STANDARD"
                    ),
                    {}
                  )
                },
                style: "STANDARD",
                padding: "STANDARD",
                marginBelow: "STANDARD"
              ),
              {}
            ),

            /* ========== ALERT IN CASO DI ANOMALIA ========== */
            if(
              or(
                local!nmvsStatus = "SOSPETTO",
                local!nmvsStatus = "ERRORE",
                local!atdStatus = "MANOMESSO"
              ),
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(
                        icon: "exclamation-triangle",
                        size: "LARGE",
                        color: "NEGATIVE"
                      ),
                      " ",
                      a!richTextItem(
                        text: "ANOMALIA RILEVATA - BLOCCO DISPENSAZIONE",
                        size: "LARGE",
                        style: "STRONG",
                        color: "NEGATIVE"
                      )
                    }
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "È stata rilevata un'anomalia durante la verifica. La confezione NON può essere dispensata.",
                        size: "MEDIUM"
                      )
                    },
                    marginBelow: "STANDARD"
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Procedura da seguire:",
                        style: "STRONG"
                      ),
                      char(10),
                      a!richTextBulletedList(
                        items: {
                          "Trattenere la confezione interessata",
                          "Non procedere con la dispensazione",
                          "Segnalare l'anomalia al responsabile",
                          "Attendere istruzioni dal sistema di Alert (EMVS/NMVS)",
                          "Documentare l'evento nel registro anomalie"
                        }
                      )
                    }
                  ),
                  a!buttonArrayLayout(
                    buttons: {
                      a!buttonWidget(
                        label: "Segnala Anomalia",
                        icon: "flag",
                        style: "SOLID"
                      ),
                      a!buttonWidget(
                        label: "Stampa Report",
                        icon: "print",
                        style: "OUTLINE"
                      )
                    },
                    align: "START",
                    marginAbove: "STANDARD"
                  )
                },
                style: "ERROR",
                padding: "STANDARD",
                marginBelow: "STANDARD"
              ),
              {}
            ),

            /* ========== RIEPILOGO STATO VERIFICHE ========== */
            if(
              local!scanCompleted,
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(
                        icon: "list-alt",
                        size: "MEDIUM",
                        color: "ACCENT"
                      ),
                      " ",
                      a!richTextItem(
                        text: "RIEPILOGO STATO VERIFICHE",
                        size: "MEDIUM",
                        style: "STRONG"
                      )
                    }
                  ),
                  a!columnsLayout(
                    columns: {
                      a!columnLayout(
                        contents: {
                          a!richTextDisplayField(
                            label: "Scansione DataMatrix",
                            value: {
                              a!richTextIcon(
                                icon: if(local!scanCompleted, "check", "circle-o"),
                                color: if(local!scanCompleted, "POSITIVE", "SECONDARY")
                              ),
                              " ",
                              a!richTextItem(
                                text: if(local!scanCompleted, "Completata", "In attesa")
                              )
                            }
                          )
                        }
                      ),
                      a!columnLayout(
                        contents: {
                          a!richTextDisplayField(
                            label: "Verifica NMVS",
                            value: {
                              a!richTextIcon(
                                icon: if(
                                  len(local!nmvsStatus) > 0,
                                  if(local!nmvsStatus = "AUTENTICO", "check", "times"),
                                  "circle-o"
                                ),
                                color: if(
                                  len(local!nmvsStatus) > 0,
                                  if(local!nmvsStatus = "AUTENTICO", "POSITIVE", "NEGATIVE"),
                                  "SECONDARY"
                                )
                              ),
                              " ",
                              a!richTextItem(
                                text: if(
                                  len(local!nmvsStatus) > 0,
                                  local!nmvsStatus,
                                  "In attesa"
                                )
                              )
                            }
                          )
                        }
                      ),
                      a!columnLayout(
                        contents: {
                          a!richTextDisplayField(
                            label: "Controllo ATD",
                            value: {
                              a!richTextIcon(
                                icon: if(
                                  len(local!atdStatus) > 0,
                                  if(local!atdStatus = "INTEGRO", "check", "times"),
                                  "circle-o"
                                ),
                                color: if(
                                  len(local!atdStatus) > 0,
                                  if(local!atdStatus = "INTEGRO", "POSITIVE", "NEGATIVE"),
                                  "SECONDARY"
                                )
                              ),
                              " ",
                              a!richTextItem(
                                text: if(
                                  len(local!atdStatus) > 0,
                                  local!atdStatus,
                                  "In attesa"
                                )
                              )
                            }
                          )
                        }
                      ),
                      a!columnLayout(
                        contents: {
                          a!richTextDisplayField(
                            label: "Decommissioning UI",
                            value: {
                              a!richTextIcon(
                                icon: if(local!decommissioningCompleted, "check", "circle-o"),
                                color: if(local!decommissioningCompleted, "POSITIVE", "SECONDARY")
                              ),
                              " ",
                              a!richTextItem(
                                text: if(local!decommissioningCompleted, "Completato", "In attesa")
                              )
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
              {}
            )
          }
        )
      }
    )
)
