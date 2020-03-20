#pragma once

#include <stdio.h>

/*
 * Doubly connected edge list utilities.
 */

struct _halfedge;

typedef struct {
    int x, y, name;
    struct _halfedge* incident_edge;
} vertex;

typedef struct {
    struct _halfedge* outer_component, *inner_component;
    int name;
} face;

typedef struct _halfedge {
    struct _halfedge* twin, *next, *prev;
    vertex* origin;
    face* incident_face;
} halfedge;

typedef struct {
    vertex* verts;
    int num_verts;

    halfedge* halfedges;
    int num_halfedges;

    face* faces;
    int num_faces;
} dcel;

void dcel_init(dcel* dst);
void dcel_free(dcel* dst);

void dcel_print_edge(halfedge* e, FILE* out);
void dcel_write(dcel* dst, FILE* out);

vertex* dcel_new_vertex(dcel* dst);
halfedge* dcel_new_halfedge(dcel* dst);
face* dcel_new_face(dcel* dst);
