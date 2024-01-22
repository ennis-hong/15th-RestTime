import { library, dom } from "@fortawesome/fontawesome-svg-core"
import { faCartShopping } from "@fortawesome/free-solid-svg-icons/faCartShopping"
import { faUser } from "@fortawesome/free-solid-svg-icons/faUser"
import { faTrash } from "@fortawesome/free-solid-svg-icons/faTrash"

library.add(faCartShopping, faUser, faTrash)
dom.watch()
