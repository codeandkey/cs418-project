#include "dcel.h"

#include <stdlib.h>
#include <string.h>

void dcel_init(dcel* dst) {
    memset(dst, 0, sizeof *dst);
}

void dcel_free(dcel* dst) {
    if (dst->verts) free(dst->verts);
    if (dst->halfedges) free(dst->halfedges);
    if (dst->faces) free(dst->faces);

    dcel_init(dst);
}

void dcel_write(dcel* dst, FILE* out) {
    for (int i = 0; i < dst->num_verts; ++i) {
        vertex* v = dst->verts + i;

        fprintf(out, "v%d (%d, %d)", v->name, v->x, v->y);
        dcel_print_edge(v->incident_edge, out);
        fprintf(out, "\n");
    }

    fprintf(out, "\n");

    for (int i = 0; i < dst->num_faces; ++i) {
        face* f = dst->faces + i;

        fprintf(out, "f%d ", f->name);
        dcel_print_edge(f->outer_component, out);
        fprintf(out, " ");
        dcel_print_edge(f->inner_component, out);
        fprintf(out, "\n");
    }

    fprintf(out, "\n");

    for (int i = 0; i < dst->num_halfedges; ++i) {
        halfedge* e = dst->halfedges + i;

        dcel_print_edge(e, out);
        fprintf(out, " v%d ", e->origin->name);
        dcel_print_edge(e->twin, out);
        fprintf(out, " f%d ", e->incident_face->name);
        dcel_print_edge(e->next, out);
        fprintf(out, " ");
        dcel_print_edge(e->prev, out);
        fprintf(out, "\n");
    }
}

void dcel_print_edge(halfedge* e, FILE* out) {
    if (e) {
        fprintf(out, "e%d,%d", e->origin->name, e->twin->origin->name);
    } else {
        fprintf(out, "nil");
    }
}

vertex* dcel_new_vertex(dcel* dst) {
    vertex* out = dst->verts + dst->num_verts;
    dst->verts = realloc(dst->verts, ++dst->num_verts * sizeof dst->verts[0]);

    memset(out, 0, sizeof *out);
    return out;
}

halfedge* dcel_new_halfedge(dcel* dst) {
    halfedge* out = dst->halfedges + dst->num_halfedges;
    dst->halfedges = realloc(dst->halfedges, ++dst->num_halfedges * sizeof dst->halfedges[0]);

    memset(out, 0, sizeof *out);
    return out;
}

face* dcel_new_face(dcel* dst) {
    face* out = dst->faces + dst->num_faces;
    dst->faces = realloc(dst->faces, ++dst->num_faces * sizeof dst->faces[0]);

    memset(out, 0, sizeof *out);
    return out;
}
